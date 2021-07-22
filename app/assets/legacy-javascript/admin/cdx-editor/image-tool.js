/* global $, EditorTool, Util, ImageUploader, translate */
/* exported ImageTool */

class ImageTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="image icon"></i>',
      title: translate.content.blocks.image,
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {}
  }

  constructor({data, _config, api}) {
    const asGallery = data.asGallery || false
    let position = ['left', 'right', 'center'].includes(data.position) ? data.position : 'center'
    if (asGallery) position = null

    super({ // Data
      id: data.id || Util.generateId(),
      items: data.items || [],
      size: ['narrow', 'wide'].includes(data.size) ? data.size : 'narrow',
      position: position,
      asGallery: asGallery,
      decorations: data.decorations || {}
    }, { // Config
      id: 'image',
      decorations: ['triangle'],
      fields: {},
      tunes: [
        {
          name: 'left',
          icon: 'indent',
          group: 'position',
        },
        {
          name: 'center',
          icon: 'align center',
          group: 'position',
        },
        {
          name: 'right',
          icon: 'horizontally flipped indent',
          group: 'position',
        },
        {
          name: 'narrow',
          icon: 'compress',
          group: 'size',
        },
        {
          name: 'wide',
          icon: 'arrows alternate horizontal',
          group: 'size',
        },
        {
          name: 'asGallery',
          icon: 'clone',
        },
      ],
    }, api)

    this.CSS.items = `${this.CSS.container}__items`
    this.CSS.item = {
      container: `${this.CSS.container}__item`,
      image: `${this.CSS.items}__image`,
      alt: `${this.CSS.items}__alt`,
      caption: `${this.CSS.items}__caption`,
      credit: `${this.CSS.items}__credit`,
      remove: `${this.CSS.items}__remove`,
    }
  }

  render() {
    this.container = super.render()

    this.uploader = new ImageUploader(this.container)
    this.uploader.addEventListener('uploadstart', event => this.addFile(event.detail.index, event.detail.file))
    this.uploader.addEventListener('uploadend', event => this._onUpload(event.detail.index, event.detail.response))

    this.itemsContainer = Util.make('div', this.CSS.items, {}, this.container)

    if (this.data.items.length) {
      if (!this.allowMultiple) $(this.uploader.wrapper).hide()

      this.data.items.forEach(item => {
        this.itemsContainer.appendChild(this.renderItem(item))
      })
    }

    this.uploader.setAllowMultiple(this.allowMultiple)
    return this.container
  }

  renderItem(item = {}) {
    const container = Util.make('div', this.CSS.item.container, {})

    if (item.image && item.image.preview) {
      const img = Util.make('div', [this.CSS.item.image, 'ui', 'fluid', 'rounded', 'image'], {}, container)
      Util.make('img', null, { src: item.image.preview }, img)
      img.dataset.attributes = JSON.stringify(item.image)
    } else {
      Util.make('div', [this.CSS.item.image, 'ui', 'fluid', 'placeholder'], {}, container)
    }

    let alt = Util.make('div', [this.CSS.input, this.CSS.inputs.text, this.CSS.item.alt], {
      contentEditable: true,
      innerHTML: item.alt || '',
    }, container)

    alt.dataset.placeholder = translate.content.placeholders.alt
    alt.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))

    let caption = Util.make('div', [this.CSS.input, this.CSS.inputs.alt, this.CSS.item.caption], {
      contentEditable: true,
      innerHTML: item.caption || '',
    }, container)

    caption.dataset.placeholder = translate.content.placeholders.caption
    caption.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))

    let credit = Util.make('div', [this.CSS.input, this.CSS.inputs.caption, this.CSS.item.credit], {
      contentEditable: true,
      innerHTML: item.credit || '',
    }, container)

    credit.dataset.placeholder = translate.content.placeholders.credit
    credit.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))

    let remove = Util.make('i', [this.CSS.item.remove, 'ui', 'times', 'circle', 'fitted', 'link', 'icon'], {}, container)
    remove.addEventListener('click', (event) => this.removeItem(event.target.parentNode))

    return container
  }

  _onUpload(index, data) {
    this.itemsContainer.querySelector(`[data-index="${index}"]`).dataset.attributes = JSON.stringify(data)
  }

  removeItem(item) {
    if (this.allowMultiple) {
      item.remove()
    } else {
      // If we are in single mode, then remove all images, to tidy up and stray images from the gallery mode.
      this.itemsContainer.innerHTML = ''
    }

    // Show the uploader if there are no images currently shown.
    if (this.itemsContainer.childElementCount === 0) {
      $(this.uploader.wrapper).show()
    }
  }

  addFile(index, file) {
    const item = this.renderItem()
    this.itemsContainer.appendChild(item)

    const reader = new FileReader()
    reader.readAsDataURL(file)
    reader.onloadend = () => {
      const image = Util.make('div', [this.CSS.item.image, 'ui', 'fluid', 'rounded', 'image'])
      Util.make('img', null, { src: reader.result }, image)
      image.dataset.index = index
      item.querySelector(`.${this.CSS.item.image}`).replaceWith(image)
    }

    // Hide the uploader if we are using the single uploader and there is already an uploaded image.
    if (!this.allowMultiple && this.itemsContainer.childElementCount > 0) {
      $(this.uploader.wrapper).hide()
    }
  }

  save(_toolElement) {
    let newData = {}
    newData.media_files = []
    newData.items = []

    for (let i = 0; i < this.itemsContainer.childElementCount; i++) {
      const item = this.itemsContainer.children[i]
      const image = JSON.parse(item.querySelector(`.${this.CSS.item.image}`).dataset.attributes)
      const itemData = {
        image: image,
        alt: item.querySelector(`.${this.CSS.item.alt}`).innerText,
        caption: item.querySelector(`.${this.CSS.item.caption}`).innerText,
        credit: item.querySelector(`.${this.CSS.item.credit}`).innerText,
      }

      if (!this.allowMultiple) {
        itemData.credit = item.querySelector(`.${this.CSS.item.credit}`).innerText
      }

      newData.media_files.push(image.id)
      newData.items.push(itemData)

      //if (!this.allowMultiple) break // TODO: Only save one image, if we are in single mode.
    }

    return Object.assign(this.data, newData)
  }

  selectTune(tune) {
    let active = super.selectTune(tune)

    if (tune.name == 'asGallery') {
      this.setTuneValue('position', active ? null : 'center')
      this.setTuneValue('size', this.data.size || 'narrow')
    } else if (active && tune.group == 'position') {
      this.setTuneBoolean('asGallery', false)
      this.setTuneValue('size', tune.name != 'center' ? null : 'narrow')
    } else if (active && tune.group == 'size') {
      const asGallery = this.isTuneActive({ name: 'asGallery' })
      this.setTuneValue('position', asGallery ? null : 'center')
    }

    const allowMultiple = tune.name == 'asGallery' ? active : this.allowMultiple
    this.uploader.setAllowMultiple(allowMultiple)
    $(this.uploader.wrapper).toggle(allowMultiple || this.itemsContainer.childElementCount === 0)
  }

  // A simple shorthand function
  get allowMultiple() {
    return this.isTuneActive({ name: 'asGallery' })
  }

  static get enableLineBreaks() {
    return true
  }

  // Empty image block is not empty Block
  static get contentless() {
    return false
  }
}
