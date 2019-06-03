
class LinkTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="linkify icon"></i>',
      title: 'Links',
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      action: false,
      url: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      action: data.action || '',
      url: data.url || '',
      items: data.items || [],
      format: ['button', 'articles', 'treatments'].includes(data.format) ? data.format : 'button',
      decorations: data.decorations || {},
    }, { // Config
      id: 'link',
      decorations: ['sidetext'],
      fields: {
        items: { label: 'Items', input: false },
        action: { label: 'Button Text', input: 'button' },
        url: { label: 'Paste a link here', input: 'url' },
      },
      tunes: [
        {
          name: 'button',
          label: 'Button',
          icon: 'hand point up outline',
          group: 'format',
        },
        {
          name: 'articles',
          label: 'Articles',
          icon: 'file text',
          group: 'format',
        },
        {
          name: 'treatments',
          label: 'Techniques',
          icon: 'sun',
          group: 'format',
        },
      ],
    }, api)

    this.CSS.fields.format = `${this.CSS.container}__format`
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

    this.formatLabel = make('div', this.CSS.fields.format, {}, container)
    make('i', 'icon', {}, this.formatLabel)
    make('span', null, {}, this.formatLabel)

    const searchInputWrapper = make('div', [this.CSS.search.input_wrapper, 'ui', 'fluid', 'icon', 'input'], {}, container)
    this.searchInput = make('input', this.CSS.search.input, {
      placeholder: 'Search articles',
    }, searchInputWrapper)
    make('i', ['search', 'icon'], {}, searchInputWrapper)

    this.searchInput.addEventListener('keyup', (event) => this._onSearchChange(event))

    this.searchContainer = make('div', [this.CSS.search.container, 'ui', 'list'], {}, container)

    this.itemsInput = make('input', this.CSS.fields.items, {
      type: 'hidden',
      value: this.data.items.map(item => item.id).join(','),
    }, container)

    this.itemsContainer = make('div', [this.CSS.items_container, 'ui', 'list'], {}, container)
    if (this.data.items.length) {
      this.data.items.forEach(item => {
        this.itemsContainer.appendChild(this.renderItem(item))
      })
    }

    container.addEventListener('click', (event) => {
      if (event.target.classList.contains('link') && event.target.classList.contains('icon')) {
        this._onItemIconClick(event)
      }
    })

    // Update the format label
    for (let i = 0; i < this.tunes.length; i++) {
      const tune = this.tunes[i];
      if (tune.group == 'format' && this.data.format == tune.name) {
        this.updateFormatLabel(tune)
        break
      }
    }

    return container
  }

  renderItem(item, selected = true) {
    const container = make('div', 'item', { id: `${this.data.format}_${item.id}` })
    const state = selected ? 'check' : 'plus'
    make('i', [state, 'circle', 'link', 'icon'], {}, container)
    make('div', 'content', { innerText: item.name }, container)
    container.dataset.id = item.id
    container.dataset.name = item.name

    return container
  }

  _onSearchChange(event) {
    if (this.timer) clearTimeout(this.timer)
    if (event.target.value.length < 3) {
      this.searchInput.parentNode.classList.remove('loading')
      return
    }

    this.searchInput.parentNode.classList.add('loading')
    this.timer = setTimeout(() => {
      // TODO: Localize this
      jQuery.get(`/en/admin/${this.data.format}.json`, {
        q: event.target.value,
      }, data => {
        this.searchContainer.innerHTML = ''
        if (data.length) {
          data.forEach(item => {
            if (document.getElementById(`${this.data.format}_${item.id}`) == null) {
              const el = this.renderItem(item, false)
              el.dataset.id = item.id
              this.searchContainer.appendChild(el)
            }
          })
        } else {
          // TODO: Translate this
          this.searchContainer.innerText = 'No results found...'
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
    let current_format = this.data.format
    let active = super.selectTune(tune)

    // If the format changes we clear the items data
    if (active && current_format != tune.name) {
      this.searchInput.value = ''
      this.itemsInput.value = ''
      this.searchContainer.innerHTML = ''
      this.itemsContainer.innerHTML = ''
      this.updateFormatLabel(tune)
    }
  }

  updateFormatLabel(tune) {
    if (tune.name != 'button') {
      this.formatLabel.querySelector('.icon').className = `${tune.icon} icon`
      this.formatLabel.querySelector('span').innerText = `${tune.label} List`
    }

    $(this.formatLabel).toggle(tune.name != 'button')
  }

  // Empty Structured is not empty Block
  static get contentless() {
    return false;
  }
}
