
class Video {

  constructor(element) {
    this.container = element
    this.originalHTML = element.outerHTML
    this.button = element.querySelector('.video__button')
    this.orientation = element.dataset.orientation
    const configElement = element.querySelector('.video__plyr')

    if (Application.isTouchDevice || this.orientation == 'vertical') {
      this.player = new Plyr(configElement, {
        fullscreen: { iosNative: true },
      })
    } else {
      this.player = new Plyr(configElement)
    }

    this.player.once('play', () => {
      this.container.classList.add('video--active')
    })

    this.validateOrientationCallback = () => this.validateOrientation()
    this.player.on('play', () => this.toggleOrientationCheck(true))
    this.player.on('pause', () => this.toggleOrientationCheck(false))

    this.button.addEventListener('click', () => this.loadPlayer())
  }

  validateOrientation() {
    if (this.player.playing && !player.fullscreen.active && Application.orientation != this.orientation) {
      this.player.pause()
    }
  }

  toggleOrientationCheck(enable) {
    if (enable) {
      window.addEventListener('orientationchange', this.validateOrientationCallback)
      window.addEventListener('resize', this.validateOrientationCallback)
    } else {
      window.removeEventListener('orientationchange', this.validateOrientationCallback)
      window.removeEventListener('resize', this.validateOrientationCallback)
    }
  }

  loadPlayer() {
    this.button.classList.add('video__button--loading')
    this.player.play()
  }

  unload() {
    this.player.destroy()
  }

}
