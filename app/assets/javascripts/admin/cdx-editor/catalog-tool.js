/* global $, EditorTool, Util, translate */
/* exported CatalogTool */

class CatalogTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="sitemap icon"></i>',
      title: translate.content.blocks.catalog,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || Util.generateId(),
      title: data.title || '',
      items: data.items || [],
      withImages: data.withImages == false ? false : true,
      type: ['articles', 'treatments', 'meditations'].includes(data.type) ? data.type : 'articles',
      decorations: data.decorations || {},
    }, { // Config
      id: 'catalog',
      decorations: ['sidetext'],
      fields: {
        title: { contrain: true },
        items: { input: false },
      },
      tunes: [
        {
          name: 'articles',
          icon: 'file text',
          group: 'type',
        },
        {
          name: 'treatments',
          icon: 'sun',
          group: 'type',
        },
        {
          name: 'meditations',
          icon: 'fire',
          group: 'type',
        },
        {
          name: 'withImages',
          icon: 'image',
        },
      ],
    }, api)

    this.CSS.fields.type = `${this.CSS.container}__type`
    this.CSS.items_display = `${this.CSS.fields.items}__display`
    this.CSS.items_container = `${this.CSS.fields.items}__container`
    this.CSS.search = {
      container: `${this.CSS.container}__search_results`,
      item: `${this.CSS.container}__search_item`,
      input: `${this.CSS.container}__search`,
      input_wrapper: `${this.CSS.container}__search_wrapper`,
    }
  }

  render() {
    const container = super.render()

    this.typeLabel = Util.make('div', this.CSS.fields.type, {})
    Util.make('i', 'icon', {}, this.typeLabel)
    Util.make('span', null, {}, this.typeLabel)
    container.prepend(this.typeLabel)

    const searchInputWrapper = Util.make('div', [this.CSS.search.input_wrapper, 'ui', 'fluid', 'icon', 'input'], {}, container)
    this.searchInput = Util.make('div', [this.CSS.search.input, this.CSS.semanticInput], {
      placeholder: `${translate.content.placeholders.search} ${translate.content.tunes.type[this.data.type].toLowerCase()}`,
      contentEditable: true,
    }, searchInputWrapper)
    this.searchInput.dataset.placeholder = `${translate.content.placeholders.search} ${translate.content.tunes.type[this.data.type].toLowerCase()}`
    Util.make('i', ['search', 'icon'], {}, searchInputWrapper)

    this.searchInput.addEventListener('keyup', event => this._onSearchChange(event))

    this.searchContainer = Util.make('div', [this.CSS.search.container, 'ui', 'list'], {}, container)

    this.itemsInput = Util.make('input', this.CSS.fields.items, {
      type: 'hidden',
      value: this.data.items.map(item => item.id).join(','),
    }, container)

    this.itemsContainer = Util.make('div', [this.CSS.items_container, 'ui', 'list'], {}, container)
    if (this.data.items.length) {
      this.data.items.forEach(item => {
        this.itemsContainer.appendChild(this.renderItem(item))
      })
    }

    this.searchContainer.addEventListener('click', (event) => {
      if (event.target.classList.contains('link') && event.target.classList.contains('icon')) {
        this._onItemIconClick(event)
      }
    })

    this.itemsContainer.addEventListener('click', (event) => {
      if (event.target.classList.contains('link') && event.target.classList.contains('icon')) {
        this._onItemIconClick(event)
      }
    })

    // Update the type label
    for (let i = 0; i < this.tunes.length; i++) {
      const tune = this.tunes[i]
      if (tune.group == 'type' && this.data.type == tune.name) {
        this.updateTypeLabel(tune)
        break
      }
    }

    return container
  }

  renderItem(item, selected = true) {
    const container = Util.make('div', 'item', { id: `${this.data.type}_${item.id}` })
    const state = selected ? 'check' : 'plus'
    Util.make('i', [state, 'circle', 'link', 'icon'], {}, container)
    Util.make('div', 'content', { innerText: item.name }, container)
    container.dataset.id = item.id
    container.dataset.name = item.name

    return container
  }

  _onSearchChange(event) {
    if (this.timer) clearTimeout(this.timer)
    if (event.target.innerText.length < 3) {
      this.searchInput.parentNode.classList.remove('loading')
      return
    }

    this.searchInput.parentNode.classList.add('loading')
    this.timer = setTimeout(() => {
      $.get(`/${locale}/${this.data.type}.json`, {
        q: event.target.innerText,
      }, data => {
        this.searchContainer.innerHTML = ''
        if (data.length) {
          data.forEach(item => {
            if (this.container.querySelector(`#${this.data.type}_${item.id}`) == null) {
              const el = this.renderItem(item, false)
              el.dataset.id = item.id
              this.searchContainer.appendChild(el)
            }
          })
        } else {
          this.searchContainer.innerText = translate.no_results
        }

        this.searchInput.parentNode.classList.remove('loading')
      }, 'json')
    }, 1000)
  }

  _onItemIconClick(event) {
    const icon = event.target
    const item = icon.parentNode

    if (icon.classList.contains('plus')) {
      // Add the item
      icon.classList.replace('plus', 'check')
      this.itemsInput.value = this.itemsInput.value ? `${this.itemsInput.value},${item.dataset.id}` : item.dataset.id
      this.itemsContainer.appendChild(item)
    } else {
      // Remove the item
      this.itemsInput.value = this.itemsInput.value.split(',').filter(id => id != item.dataset.id).join(',')
      item.remove()
    }
  }

  save(toolElement) {
    const data = super.save(toolElement)
    data.items = []

    for (let i = 0; i < this.itemsContainer.childElementCount; i++) {
      const item = this.itemsContainer.children[i]
      data.items.push({ id: item.dataset.id, name: item.dataset.name })
    }

    return this.data
  }

  selectTune(tune) {
    const currentType = this.data.type
    const active = super.selectTune(tune)

    // If the type changes we clear the items data
    if (active && tune.group == 'type' && currentType != tune.name) {
      this.searchInput.value = ''
      this.itemsInput.value = ''
      this.searchContainer.innerHTML = ''
      this.itemsContainer.innerHTML = ''
      this.updateTypeLabel(tune)
    }
  }

  updateTypeLabel(tune) {
    this.typeLabel.querySelector('.icon').className = `${tune.icon} icon`
    this.typeLabel.querySelector('span').innerText = translate.content.tunes[tune.group][tune.name]
    this.searchInput.dataset.placeholder = `${translate.content.placeholders.search} ${translate.content.tunes[tune.group][tune.name].toLowerCase()}`
  }

  static get enableLineBreaks() {
    return true
  }

  // Empty Structured is not empty Block
  static get contentless() {
    return false
  }
}
