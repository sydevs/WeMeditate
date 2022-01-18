import { make } from '../util'
import { translate } from '../../i18n'
import { uploadFile } from '../features/uploader'

const ACCEPTS = {
  file: '',
  image: 'image/png, image/jpg, image/jpeg, image/gif, image/svg+xml',
  audio: 'audio/mpeg',
}

export default class FileUploader {

  constructor(container = null, type = 'image', key = '') {
    type = Object.keys(ACCEPTS).includes(type) ? type : 'file'
    this.fileCounter = 0

    this.wrapper = make('div', 'uploader', { data: { type: type, key: key } }, container)
    this.input = make('input', '', { type: 'file', accept: ACCEPTS[type] }, this.wrapper)
    this.changeType(type)

    this.wrapper.addEventListener('dragover', event => {
      event.preventDefault()
    })

    this.wrapper.addEventListener('dragenter', event => {
      event.target.classList.add('uploader--dropping')
      event.target.classList.remove('uploader--error')
      event.preventDefault()
    })

    this.wrapper.addEventListener('dragleave', event => {
      event.target.classList.remove('uploader--dropping')
    })

    this.wrapper.addEventListener('click', () => this.input.click())
    this.wrapper.addEventListener('drop', event => this._onFileDrop(event))
    this.input.addEventListener('change', event => this._onImageSelect(event))
  }

  refreshText() {
    this.wrapper.innerText = translate('uploader.drag', { file: translate(`uploader.${this.type}.${this.allowMultiple ? 'many' : 'one'}`).toLowerCase() })
  }

  changeType(type) {
    this.type = type
    this.input.setAttribute('accept', ACCEPTS[type])
    this.refreshText()
  }

  _onImageSelect(event) {
    for (let i = 0; i < event.target.files.length; i++) {
      const added = this.uploadFile(event.target.files[i])
      if (added && !this.allowMultiple) break
    }
  }

  _onFileDrop(event) {
    if (event.dataTransfer.items) {
      // Use DataTransferItemList interface to access the file(s)
      for (let i = 0; i < event.dataTransfer.items.length; i++) {
        if (event.dataTransfer.items[i].kind === 'file') { // If dropped items aren't files, ignore them
          const added = this.uploadFile(event.dataTransfer.items[i].getAsFile())
          if (added && !this.allowMultiple) break
        }
      }
    } else {
      // Use DataTransfer interface to access the file(s)
      for (let i = 0; i < event.dataTransfer.files.length; i++) {
        const added = this.uploadFile(event.dataTransfer.files[i])
        if (added && !this.allowMultiple) break
      }
    }

    event.preventDefault() // Prevent file from being opened
  }

  isAcceptedFileType(file) {
    return this.input.accept.includes(file.type)
  }

  uploadFile(file) {
    if (!this.isAcceptedFileType(file)) return false

    const index = this.fileCounter
    this.fileCounter++

    const event = new CustomEvent('uploadstart', { detail: { index: index, file: file } })
    this.wrapper.dispatchEvent(event)

    uploadFile(file, (result) => {
      const event = new CustomEvent('uploadend', { detail: { index: index, response: result } })
      this.wrapper.dispatchEvent(event)
    }, (result) => {
      const event = new CustomEvent('uploadfailed', { detail: { index: index, response: result } })
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

    this.refreshText()
  }

  addEventListener(type, callback) {
    this.wrapper.addEventListener(type, callback)
  }
}
