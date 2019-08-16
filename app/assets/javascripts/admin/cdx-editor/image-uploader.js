
class ImageUploader {

  constructor(container = null) {
    this.index_counter = 0
    this.CSS = {
      dropzone: 'cdx-input__uploader',
      dropping: 'cdx-input__uploader--dropping',
      error: 'cdx-input__uploader--error',
    }

    this.accepts = ['image/png', 'image/jpg', 'image/jpeg']
    this.fileQueue = []

    this.wrapper = make('div', this.CSS.dropzone, { innerHTML: translate['drag_images_to_upload'] }, container)
    this.input = make('input', '', { type: 'file', accept: this.accepts.join(',') }, this.wrapper)

    this.wrapper.addEventListener('dragover', event => {
      event.preventDefault()
    })

    this.wrapper.addEventListener('dragenter', event => {
      event.target.classList.add(this.CSS.dropping)
      event.target.classList.remove(this.CSS.error)
      event.preventDefault()
    })

    this.wrapper.addEventListener('dragleave', event => {
      event.target.classList.remove(this.CSS.dropping)
    })

    this.wrapper.addEventListener('click', () => this.input.click())
    this.wrapper.addEventListener('drop', event => this._onImageDrop(event))
    this.input.addEventListener('change', event => this._onImageSelect(event))
  }

  _onImageSelect(event) {
    for (var i = 0; i < event.target.files.length; i++) {
      const added = this.uploadFile(event.target.files[i])
      if (added && !this.allowMultiple) break
    }
  }

  _onImageDrop(event) {
    console.log('File(s) dropped', event.dataTransfer.items)

    if (event.dataTransfer.items) {
      // Use DataTransferItemList interface to access the file(s)
      for (var i = 0; i < event.dataTransfer.items.length; i++) {
        if (event.dataTransfer.items[i].kind === 'file') { // If dropped items aren't files, ignore them
          const added = this.uploadFile(event.dataTransfer.items[i].getAsFile())
          if (added && !this.allowMultiple) break
        }
      }
    } else {
      // Use DataTransfer interface to access the file(s)
      for (var i = 0; i < event.dataTransfer.files.length; i++) {
        const added = this.uploadFile(event.dataTransfer.files[i])
        if (added && !this.allowMultiple) break
      }
    }

    event.preventDefault() // Prevent file from being opened
  }

  isAcceptedFileType(file) {
    return this.accepts.includes(file.type)
  }

  uploadFile(file) {
    if (!this.isAcceptedFileType(file)) return false

    const index = this.index_counter
    this.index_counter++

    const event = new CustomEvent('uploadstart', { detail: { index: index, file: file } })
    this.wrapper.dispatchEvent(event)

    Editor.upload(file, (result) => {
      console.log('uploaded', result)
      const event = new CustomEvent('uploadend', { detail: { index: index, response: result } })
      this.wrapper.dispatchEvent(event)
    })

    return true
  }

  setAllowMultiple(allow) {
    this.allowMultiple = allow

    if (allow) {
      this.input.setAttribute('multiple', true)
    } else {
      this.input.removeAttribute('multiple')
    }
  }

  addEventListener(type, callback) {
    this.wrapper.addEventListener(type, callback)
  }
}
