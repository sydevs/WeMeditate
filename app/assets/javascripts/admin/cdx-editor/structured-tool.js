/* global $, EditorTool, Util, ImageUploader, translate */
/* exported StructuredTool */

class StructuredTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="th icon"></i>',
      title: translate.content.blocks.structured,
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {}
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || Util.generateId(),
      items: data.items || [],
      format: ['grid', 'accordion', 'columns'].includes(data.format) ? data.format : 'grid',
      decorations: data.decorations || {},
    }, { // Config
      id: 'structured',
      decorations: false,
      fields: {},
      tunes: [
        {
          name: 'grid',
          icon: 'th',
          group: 'format',
        },
        {
          name: 'accordion',
          icon: 'th list',
          group: 'format',
        },
        {
          name: 'columns',
          icon: 'columns',
          group: 'format',
        },
      ],
    }, api)

    this.CSS.items = `${this.CSS.container}__items`
    this.CSS.item = {
      container: `${this.CSS.container}__item`,
      remove: `${this.CSS.container}__remove_image`,
      image: `${this.CSS.container}__image`,
      img: `${this.CSS.container}__img`,
      title: `${this.CSS.container}__title`,
      text: `${this.CSS.container}__text`,
    }
  }

  render() {
    const container = super.render()
    this.itemsContainer = Util.make('div', this.CSS.items, {}, container)

    if (this.data.items.length) {
      this.data.items.forEach(item => {
        this.itemsContainer.appendChild(this.renderItem(item))
      })
    } else {
      for (let i = 0; i < 3; i++) {
        this.itemsContainer.appendChild(this.renderItem())
      }
    }

    return container
  }

  renderItem(data = {}) {
    const container = Util.make('div', this.CSS.item.container, {})
    container.addEventListener('keydown', (event) => {
      return this._onItemKeydown(event, event.currentTarget)
    }, false)

    // Add Image uploader
    const imageContainer = Util.make('div', [this.CSS.input, this.CSS.item.image], {}, container)

    const imageUploader = new ImageUploader(imageContainer)
    imageUploader.addEventListener('uploadstart', event => this.setItemImage(container, event.detail.file))
    imageUploader.addEventListener('uploadend', event => {
      imageContainer.dataset.attributes = JSON.stringify(event.detail.response)
    })

    const imageRemoveIcon = Util.make('i', [this.CSS.item.remove, 'ui', 'times', 'circle', 'fitted', 'link', 'icon'], {}, imageContainer)
    imageRemoveIcon.addEventListener('click', () => this.setItemImage(container, null))

    if (data.image && data.image.preview) {
      Util.make('img', this.CSS.item.img, { src: data.image.preview }, imageContainer)
      imageContainer.dataset.attributes = JSON.stringify(data.image)
      $(imageUploader.wrapper).hide()
    } else {
      $(imageRemoveIcon).hide()
    }

    // Add title input
    const title = Util.make('div', [this.CSS.input, this.CSS.inputs.title, this.CSS.item.title], {
      contentEditable: true,
      innerHTML: data.title || '',
    }, container)

    title.dataset.placeholder = translate.content.placeholders.title

    // Add text input
    const text = Util.make('div', [this.CSS.input, this.CSS.inputs.text, this.CSS.item.text], {
      contentEditable: true,
      innerHTML: data.text || '',
    }, container)

    text.dataset.placeholder = translate.content.placeholders.text
    text.addEventListener('paste', event => this.containPaste(event))

    return container
  }

  setItemImage(item, file) {
    if (file) {
      const placeholder = Util.make('div', [this.CSS.item.img, 'ui', 'fluid', 'placeholder'], {})
      item.querySelector(`.${this.CSS.item.image}`).appendChild(placeholder)
      $(item.querySelector('.cdx-input__uploader')).hide()
      $(item.querySelector(`.${this.CSS.item.remove}`)).show()

      const reader = new FileReader()
      reader.readAsDataURL(file)
      reader.onloadend = () => {
        const img = Util.make('img', this.CSS.item.img, { src: reader.result })
        placeholder.replaceWith(img)
      }
    } else {
      item.querySelector(`.${this.CSS.item.image}`).dataset.attributes = null
      item.querySelector(`.${this.CSS.item.img}`).remove()
      $(item.querySelector('.cdx-input__uploader')).show()
      $(item.querySelector(`.${this.CSS.item.remove}`)).hide()
    }
  }

  _onItemKeydown(event, item) {
    if (event.key == 'Enter' || event.keyCode == 13) { // ENTER
      return this._onItemKeydownEnter(event.target, item)
    } else if (event.key == 'Backspace' || event.keyCode == 8) { // BACKSPACE
      return this._onItemKeydownBackspace(event.target, item)
    } else {
      return true
    }
  }

  _onItemKeydownEnter(input, item) {
    if (input.classList.contains(this.CSS.item.text)) {
      if (item === item.parentNode.lastChild && !item.textContent.trim().length) {
        item.parentElement.removeChild(item)
        this.api.blocks.insert()
      } else if (!Util.getSelectionTextInfo(input).atEnd) {
        this.insertParagraphBreak(event)
      } else {
        const newItem = this.renderItem()
        item.parentNode.insertBefore(newItem, item.nextSibling)
        Util.setCaretPosition(newItem.querySelector(`.${this.CSS.item.title}`))
      }
    } else {
      Util.setCaretPosition(input.nextSibling)
    }

    event.preventDefault()
    event.stopPropagation()
    return false
  }

  _onItemKeydownBackspace(input, item) {
    //if (input.classList.contains(this.CSS.item.title)) {
    const isOnlyItem = (item == item.parentNode.firstChild && item == item.parentNode.lastChild)
    const titleContent = item.querySelector(`.${this.CSS.item.title}`).innerText.trim()
    const textContent = item.querySelector(`.${this.CSS.item.text}`).innerText.trim()

    if (!isOnlyItem && !titleContent && !textContent) {
      const previousSiblingTextInput = item.previousSibling.querySelector(`.${this.CSS.item.text}`)
      Util.setCaretPosition(previousSiblingTextInput, previousSiblingTextInput.innerText.length)
      item.remove()

      event.preventDefault()
      event.stopPropagation()
      return false
    }

    return true
  }

  save(toolElement) {
    const item_data = []
    const media_files = []

    const items = toolElement.querySelector(`.${this.CSS.items}`).children
    for (let i = 0; i < items.length; i++) {
      const title = items[i].querySelector(`.${this.CSS.item.title}`).innerText
      const text = items[i].querySelector(`.${this.CSS.item.text}`).innerHTML

      if (title || text) {
        const data = { title: title, text: text }

        if (this.data.format === 'columns') {
          let imageData = items[i].querySelector(`.${this.CSS.item.image}`).dataset.attributes
          if (imageData) {
            imageData = JSON.parse(imageData)
            data.image = imageData
            if (imageData) media_files.push(imageData.id)
          }
        }

        item_data.push(data)
      }
    }

    return Object.assign(this.data, { items: item_data, media_files: media_files })
  }

  // Returns current item by the caret position
  get currentItem() {
    let currentNode = window.getSelection().anchorNode

    if (currentNode.nodeType !== Node.ELEMENT_NODE) {
      currentNode = currentNode.parentNode
    }

    return currentNode.closest(`.${this.CSS.item.container}`)
  }

  // Enable default line break handling
  static get enableLineBreaks() {
    return true
  }

  // Empty Structured is not empty Block
  static get contentless() {
    return false
  }
}
