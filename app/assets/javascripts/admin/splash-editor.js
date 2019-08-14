
const SplashEditor = {
  isActive: false,

  load() {
    const splashEditor = document.getElementById('splash-editor')
    if (!splashEditor) return

    this.isActive = true
    this.style = splashEditor.dataset.style

    this.uploader = new ImageUploader(document.getElementById('splash-uploader'))
    this.uploader.addEventListener('uploadstart', _event => this._onStartUpload())
    this.uploader.addEventListener('uploadend', event => this._onCompleteUpload(event.detail.response))

    this.backgroundImage = document.getElementById('splash-background-image')
    this.splashTitle = document.getElementById('splash-title')
    this.splashText = document.getElementById('splash-text')
    this.splashAction = document.getElementById('splash-action')
    this.splashUrl = document.getElementById('splash-url')
  },

  _onStartUpload() {
    SplashEditor.backgroundImage.innerHTML = '<div class="ui fluid placeholder"></div>'
  },

  _onCompleteUpload(data) {
    SplashEditor.backgroundImage.dataset.attributes = JSON.stringify(data)
    SplashEditor.backgroundImage.innerHTML = ''
    SplashEditor.backgroundImage.style['background-image'] = `url(${data.preview})`
  },

  setData(block) {
    const data = block.data

    if (data.image) {
      this.backgroundImage.dataset.attributes = JSON.stringify(data.image)
      this.backgroundImage.style['background-image'] = `url(${data.image.preview})`
    }

    this.splashTitle.innerText = data.title || ''
    this.splashText.innerText = data.text || ''
    this.splashAction.innerText = data.action || ''
    this.splashUrl.innerText = data.url || ''
  },

  getData() {
    const result = {
      type: 'splash',
      data: {
        title: this.splashTitle.innerText,
        text: this.splashText.innerText,
        action: this.splashAction.innerText,
        url: this.splashUrl.innerText,
        style: this.style,
      }
    }

    const image_data = JSON.parse(this.backgroundImage.dataset.attributes)
    result.data.media_files = [image_data.id]
    result.data.image = image_data
    return result
  },

}
