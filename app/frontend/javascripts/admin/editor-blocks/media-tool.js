import $ from 'jquery'
import { generateId, make } from '../util'
import { translate } from '../../i18n'
import EditorTool from './_editor-tool'
import FileUploader from '../elements/file-uploader'
import FinderModal from '../elements/finder-modal'

export default class MediaTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="photo video icon"></i>',
      title: translate('blocks.media.label'),
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || generateId(),
      poster: data.poster || {},
      items: data.items || [],
      mediaFiles: data.mediaFiles || [],
      type: ['image', 'video', 'audio', 'vimeo'].includes(data.type) ? data.type : 'none',
      quantity: ['single', 'gallery'].includes(data.quantity) ? data.quantity : 'single',
      position: ['left', 'center', 'right'].includes(data.position) ? data.position : 'center',
      size: ['narrow', 'wide'].includes(data.size) ? data.size : 'narrow',
      decorations: data.decorations || {},
    }, { // Config
      id: 'media',
      fields: {},
      tunes: {
        type: {
          options: [
            { name: 'image', icon: 'image', },
            { name: 'video', icon: 'film', },
            { name: 'audio', icon: 'volume up' },
          ]
        },
        quantity: {
          options: [
            { name: 'single', icon: 'square' },
            { name: 'gallery', icon: 'clone' },
          ]
        },
        position: {
          requires: { type: ['image'], quantity: ['single'] },
          options: [
            { name: 'left', icon: 'indent' },
            { name: 'center', icon: 'align center' },
            { name: 'right', icon: 'horizontally flipped indent' },
          ]
        },
        size: {
          requires: { type: ['image'], quantity: ['single'], position: ['center'] },
          options: [
            { name: 'narrow', icon: 'minus' },
            { name: 'wide', icon: 'arrows alternate horizontal' },
          ]
        },
      },
      decorations: {
        triangle: { requires: { type: ['image'], position: ['center'] }},
        sidetext: { requires: { type: ['video'] }},
        gradient: { requires: { type: ['video'] }},
      }
    }, api)

    this.CSS.finder = `${this.CSS.container}__finder`
    this.CSS.poster = `${this.CSS.container}__poster`
    this.CSS.items = `${this.CSS.container}__items`
    this.CSS.picker = {
      container: `${this.CSS.container}__picker`,
      title: `${this.CSS.container}__picker__title`,
      item: `${this.CSS.container}__picker__item`,
    }

    this.CSS.item = {
      container: `${this.CSS.container}__item`,
      image: `${this.CSS.items}__image`,
      title: `${this.CSS.items}__title`,
      alt: `${this.CSS.items}__alt`,
      caption: `${this.CSS.items}__caption`,
      credit: `${this.CSS.items}__credit`,
      remove: `${this.CSS.items}__remove`,
    }
  }

  render() {
    this.container = super.render()

    this.typeSelector = make('div', this.CSS.picker.container, {}, this.container)
    make('div', this.CSS.picker.title, { innerText: translate('blocks.media.picker') }, this.typeSelector)
    this.tunes.type.options.forEach(item => {
      let itemContainer = make('div', this.CSS.picker.item, {}, this.typeSelector)
      make('i', `big ${item.icon} icon`.split(' '), {}, itemContainer)
      make('label', '', { innerText: translate(`blocks.media.type.${item.name}`) }, itemContainer)
      itemContainer.addEventListener('click', _event => this.selectTune(item))
    })

    const openButton = make('div', ['ui', 'tiny', 'right', 'floated', 'button', this.CSS.finder], {})
    make('i', ['cog', 'icon'], {}, openButton)
    make('span', '', { innerText: translate('blocks.media.change') }, openButton)
    openButton.addEventListener('click', () => this.videoFinder.open(this.data.items, this.isGallery))
    this.videoFinder = new FinderModal('jwplayer', items => this._onApproveVideoFinder(items))
    this.container.prepend(openButton)

    this.posterUploader = new FileUploader(this.container, 'image', 'poster')
    this.posterUploader.addEventListener('uploadstart', event => this._onPosterUpload(event.detail.file))
    this.posterUploader.addEventListener('uploadend', event => this._onPosterUploaded(event.detail.response))

    this.uploader = new FileUploader(this.container, this.data.type, 'file')
    this.uploader.addEventListener('uploadstart', event => this.addFile(event.detail.index, event.detail.file))
    this.uploader.addEventListener('uploadend', event => this._onFileUploaded(event.detail.index, event.detail.response))

    this.poster = make('div', this.CSS.poster, {}, this.container)
    if (this.data.poster.preview) {
      make('img', null, { src: this.data.poster.preview }, this.poster)
    } else {
      make('i', ['huge', 'image', 'icon'], {}, this.poster)
    }

    this.itemsContainer = make('div', this.CSS.items, {}, this.container)

    if (this.data.items.length) {
      if (!this.isGallery) $(this.uploader.wrapper).hide()

      this.data.items.forEach(item => {
        this.itemsContainer.appendChild(this.renderItem(item))
      })
    }

    this.uploader.setAllowMultiple(this.isGallery)
    return this.container
  }

  renderItem(item = {}) {
    console.log('render item', item)
    const container = make('div', this.CSS.item.container, {})

    if (this.data.type == 'audio') {
      if (item.audio && item.audio.preview) {
        const link = make('a', null, { href: item.audio.preview, target: '_blank' }, container)
        make('i', ['play', 'circle', 'link', 'fitted', 'icon'], {}, link)
      } else {
        make('i', ['circle', 'notch', 'loading', 'icon'], {}, container)
      }
      container.dataset.attributes = JSON.stringify(item.audio)
    } else if (this.data.type == 'video') {
      const img = make('div', [this.CSS.item.image, 'ui', 'rounded', 'image'], {}, container)
      make('img', null, { src: `https://cdn.jwplayer.com/v2/media/${item.id}/poster.jpg?width=320` }, img)
      container.dataset.attributes = JSON.stringify(item)
    } else if (item.image && item.image.preview) {
      const img = make('div', [this.CSS.item.image, 'ui', 'rounded', 'image'], {}, container)
      make('img', null, { src: item.image.preview }, img)
      img.dataset.attributes = JSON.stringify(item.image)
    } else {
      make('div', [this.CSS.item.image, 'ui', 'fluid', 'placeholder'], {}, container)
    }

    if (this.data.type == 'image') {
      let alt = make('div', [this.CSS.input, this.CSS.inputs.text, this.CSS.item.alt], {
        contentEditable: true,
        innerHTML: item.alt || '',
      }, container)

      alt.dataset.placeholder = translate('placeholders.alt')
      alt.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))

      let caption = make('div', [this.CSS.input, this.CSS.inputs.alt, this.CSS.item.caption], {
        contentEditable: true,
        innerHTML: item.caption || '',
      }, container)

      caption.dataset.placeholder = translate('placeholders.caption')
      caption.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))

      let credit = make('div', [this.CSS.input, this.CSS.inputs.caption, this.CSS.item.credit], {
        contentEditable: true,
        innerHTML: item.credit || '',
      }, container)

      credit.dataset.placeholder = translate('placeholders.credit')
      credit.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))
    } else if (this.data.type == 'audio') {
      let title = make('div', [this.CSS.input, this.CSS.inputs.text, this.CSS.item.title], {
        contentEditable: true,
        innerHTML: item.title || '',
      }, container)

      title.dataset.placeholder = translate('placeholders.title')
      title.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event))
    } else {
      make('div', '', { innerHTML: item.name }, container)
    }

    let remove = make('i', [this.CSS.item.remove, 'ui', 'times', 'circle', 'fitted', 'link', 'icon'], {}, container)
    remove.addEventListener('click', (event) => this.removeItem(event.target.parentNode))

    return container
  }

  removeItem(item) {
    if (this.isGallery) {
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
    console.log('add file', file)
    const item = this.renderItem({ title: file.name })
    this.itemsContainer.appendChild(item)

    const reader = new FileReader()
    reader.readAsDataURL(file)
    reader.onloadend = () => {
      if (this.data.type == 'image') {
        const image = make('div', [this.CSS.item.image, 'ui', 'rounded', 'image'])
        make('div', ['ui', 'active', 'loader'], {}, image)
        make('img', null, { src: reader.result }, image)
        item.querySelector(`.${this.CSS.item.image}`).replaceWith(image)
      }

      item.dataset.index = index
    }

    // Hide the uploader if we are using the single uploader and there is already an uploaded image.
    if (!this.isGallery && this.itemsContainer.childElementCount > 0) {
      $(this.uploader.wrapper).hide()
    }
  }

  _onFileUploaded(index, data) {
    const item = this.itemsContainer.querySelector(`[data-index="${index}"]`)
    item.dataset.attributes = JSON.stringify(data)

    const loadingIcon = item.querySelector('.loading.icon')
    if (loadingIcon) loadingIcon.className = 'arrow alternate circle up icon'
    const loader = item.querySelector('.loader')
    if (loader) loader.remove()
  }
  
  _onPosterUpload(file) {
    const reader = new FileReader()
    reader.readAsDataURL(file)
    reader.onloadend = () => {
      this.poster.innerHTML = ''
      make('div', ['ui', 'active', 'loader'], {}, this.poster)
      make('img', null, { src: reader.result }, this.poster)
    }
  }

  _onPosterUploaded(data) {
    this.poster.dataset.attributes = JSON.stringify(data)
    this.poster.querySelector('.loader').remove()
  }
  
  _onApproveVideoFinder(items) {
    this.itemsContainer.innerHTML = ''
    this.data.items = items
    items.forEach(item => {
      const element = this.renderItem(item)
      this.itemsContainer.appendChild(element)
    })
  }

  save(_toolElement) {
    let newData = {}
    newData.mediaFiles = []
    newData.items = []

    if (this.data.type == 'image') {
      for (let i = 0; i < this.itemsContainer.childElementCount; i++) {
        const item = this.itemsContainer.children[i]
        const image = JSON.parse(item.querySelector(`.${this.CSS.item.image}`).dataset.attributes)
        const itemData = {
          image: image,
          alt: item.querySelector(`.${this.CSS.item.alt}`).innerText,
          caption: item.querySelector(`.${this.CSS.item.caption}`).innerText,
          credit: item.querySelector(`.${this.CSS.item.credit}`).innerText,
        }

        if (!this.isGallery) {
          itemData.credit = item.querySelector(`.${this.CSS.item.credit}`).innerText
        }

        newData.mediaFiles.push(image.id)
        newData.items.push(itemData)

        //if (!this.isGallery) break // TODO: Only save one image, if we are in single mode.
      }
    } else if (this.data.type == 'audio') {
      for (let i = 0; i < this.itemsContainer.childElementCount; i++) {
        const item = this.itemsContainer.children[i]
        const audio = JSON.parse(item.dataset.attributes)
        const itemData = {
          audio: audio,
          title: item.querySelector(`.${this.CSS.item.title}`).innerText,
        }

        newData.mediaFiles.push(audio.id)
        newData.items.push(itemData)

        //if (!this.isGallery) break // TODO: Only save one image, if we are in single mode.
      }

      if (this.poster.dataset.attributes) {
        newData.poster = JSON.parse(this.poster.dataset.attributes)
      }
    } else {
      for (let i = 0; i < this.itemsContainer.childElementCount; i++) {
        const item = this.itemsContainer.children[i]
        newData.items.push(JSON.parse(item.dataset.attributes))
      }
    }

    // TODO: Because of autosave, this strips out necessary defaults prematurely.
    //this.removeInactiveData()
    return Object.assign(this.data, newData)
  }

  validate(blockData) {
    return blockData.items.length > 0
  }

  selectTune(tune) {
    if (tune.group == 'type' && this.data.items.length > 0) {
      // eslint-disable-next-line no-alert
      const result = confirm(translate('blocks.media.change_warning'))
      if (!result) return
    }

    super.selectTune(tune)

    if (tune.group == 'quantity') {
      this.uploader.setAllowMultiple(this.isGallery)
      $(this.uploader.wrapper).toggle(this.isGallery || this.itemsContainer.childElementCount === 0)
    }

    if (tune.group == 'type') {
      this.itemsContainer.innerHTML = null
      this.data.items = []
      this.uploader.changeType(tune.name)
    }
  }

  get isGallery() {
    return this.data.quantity == 'gallery'
  }

  async onPaste(_event) {
    // TODO: Implement paste handlers
    // await this.pasteHandler(event)
    this.updateSettingButtons()
    this.updateSettingClasses()
  }

  async pasteHandler(event) {
    //const element = event.detail.data
    //const { tagName: tag } = element

    switch (event.type) {
    case 'tag': {
      const image = event.detail.data
      if (/^blob:/.test(image.src)) {
        const response = await fetch(image.src)
        const file = await response.blob()
        this.uploadFile(file)
        break
      }

      this.uploadUrl(image.src)
      break
    }
    case 'pattern': {
      const url = event.detail.data
      this.uploadUrl(url)
      break
    }
    case 'file': {
      const file = event.detail.file
      this.uploadFile(file)
      break
    }
    }

    /*
    this.data = {
      items: [{
        image: file,
      }]
    }
    */
  }

  // Define the types of paste that should be handled by this tool.
  static get pasteConfig() {
    return {
      tags: ['IMG'],
      patterns: {
        image: /https?:\/\/\S+\.(gif|jpe?g|tiff|png)$/i,
      },
      files: {
        mimeTypes: [ 'image/*' ],
      },
    }
  }

  static get sanitize() {
    return {}
  }

  static get enableLineBreaks() {
    return true
  }

  static get contentless() {
    return false
  }
}
