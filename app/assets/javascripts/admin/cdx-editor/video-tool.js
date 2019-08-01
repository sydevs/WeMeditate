
class VideoTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="play icon"></i>',
      title: translate['content']['blocks']['video'],
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {}
  }

  constructor({data, _config, api}) {
    super({ // Data
      items: data.items || [],
      asGallery: data.asGallery || false,
      decorations: data.decorations || {},
    }, { // Config
      id: 'video',
      decorations: ['sidetext', 'gradient'],
      fields: {},
      tunes: [
        {
          name: 'asGallery',
          icon: 'clone',
        },
      ],
    }, api)

    this.CSS.search = `${this.CSS.container}__search`
    this.CSS.items = `${this.CSS.container}__items`
    this.CSS.item = {
      container: `${this.CSS.container}__item`,
      title: `${this.CSS.items}__title`,
      image: `${this.CSS.items}__image`,
      remove: `${this.CSS.items}__remove`,
    }
  }

  render() {
    this.container = super.render()

    const searchInputWrapper = make('div', [this.CSS.search, 'ui', 'fluid', 'icon', 'input'], {}, this.container)
    this.searchInput = make('input', null, { placeholder: 'Enter Vimeo ID' }, searchInputWrapper)
    make('i', ['search', 'icon'], {}, searchInputWrapper)
    this.searchInput.addEventListener('keypress', event => {
      if (event.key == 'Enter' || event.keyCode == 13 || event.which == 13) { // ENTER
        if (!isNaN(event.target.value)) this.retrieveVimeoVideo(event.target.value)
        event.preventDefault()
        event.stopPropagation()
        return false
      }
    })

    this.itemsContainer = make('div', this.CSS.items, {}, this.container)

    if (this.data.items.length) {
      this.data.items.forEach(item => {
        this.itemsContainer.appendChild(this.renderItem(item))
      })
    }

    return this.container
  }

  renderItem(item) {
    const container = make('div', this.CSS.item.container, {})
    container.dataset.vimeoId = item.vimeo_id

    if (item.thumbnail) {
      const img = make('div', [this.CSS.item.image, 'ui', 'fluid', 'rounded', 'image'], {}, container)
      make('img', null, { src: item.thumbnail, srcset: item.thumbnail_srcset, sizes: '586px' }, img)
    } else {
      make('div', [this.CSS.item.image, 'ui', 'fluid', 'placeholder'], {}, container)
    }

    let title = make('div', [this.CSS.input, this.CSS.inputs.title, this.CSS.item.title], {
      contentEditable: true,
      innerHTML: item.title || `Video #${item.vimeo_id}`,
    }, container)

    title.dataset.placeholder = translate['content']['placeholders']['title']

    let remove = make('i', [this.CSS.item.remove, 'ui', 'times', 'circle', 'fitted', 'link', 'icon'], {}, container)
    remove.addEventListener('click', (event) => this.removeItem(event.target.parentNode))

    return container
  }

  retrieveVimeoVideo(vimeo_id) {
    this.searchInput.parentNode.classList.add('loading')
    const item = this.renderItem({ vimeo_id: vimeo_id })
    this.itemsContainer.appendChild(item)

    Editor.retrieveVimeoVideo(vimeo_id, (result) => {
      this.searchInput.parentNode.classList.remove('loading')
      this.searchInput.value = ''
      item.replaceWith(this.renderItem(result))

      // Hide the uploader if we are using the single uploader and there is already an uploaded image.
      /*if (!this.allowMultiple && this.itemsContainer.childElementCount > 0) {
        $(this.searchInput.parentNode).hide()
      }*/
    })
  }

  removeItem(item) {
    if (this.allowMultiple) {
      item.remove()
    } else {
      // If we are in single mode, then remove all videos, to tidy up and stray videos from the gallery mode.
      this.itemsContainer.innerHTML = ''
    }

    // Show the uploader if there are no images currently shown.
    /*if (this.itemsContainer.childElementCount === 0) {
      $(this.searchInput.parentNode).show()
    }*/
  }

  save(_toolElement) {
    let new_data = {}
    new_data.items = []

    for (let i = 0; i < this.itemsContainer.childElementCount; i++) {
      const item = this.itemsContainer.children[i]
      const imageElement = item.querySelector(`.${this.CSS.item.image} img`)
      console.log('saving thumbnail', `.${this.CSS.item.image}`, 'in', item, '=', item.querySelector(`.${this.CSS.item.image}`))
      new_data.items.push({
        vimeo_id: item.dataset.vimeoId,
        thumbnail: imageElement.src,
        thumbnail_srcset: imageElement.srcset,
        title: item.querySelector(`.${this.CSS.item.title}`).innerText,
      })

      //if (!this.allowMultiple) break // Only save one video, if we are in single mode.
    }

    return Object.assign(this.data, new_data)
  }

  selectTune(tune) {
    const active = super.selectTune(tune)

    //const allowMultiple = tune.name == 'asGallery' ? active : this.allowMultiple
    //$(this.searchInput.parentNode).toggle(allowMultiple || this.itemsContainer.childElementCount === 0)
  }

  // A simple shorthand function
  get allowMultiple() {
    this.isTuneActive('asGallery')
  }

  // Allow native enter behaviour
  static get enableLineBreaks() {
    return true
  }

  // Empty video block is not empty Block
  static get contentless() {
    return false
  }
}
