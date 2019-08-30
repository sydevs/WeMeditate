
class Video {

    constructor(element, index) {
    this.popout = $(element).magnificPopup({
      key: 'video',
      callbacks: {
        open: function() {
          Video.loadVimeoId(this.ev[0].dataset.id)

          if (Video.useAutoFullscreen()) {
            Application.videoPlayer.fullscreen.enter()
          }
        }
      },
    })
  }

  static unloadPlayer() {
    Application.videoPlayer.destroy()
  }

  static loadPlayer(id) {
    const videoPlayerContainer = document.getElementById(id)
    const videoPlayer = new Plyr(videoPlayerContainer, {
      fullscreen: { iosNative: true },
    })

    if (Video.useAutoFullscreen()) {
      videoPlayer.on('exitfullscreen', () => $.magnificPopup.close())
    }

    return videoPlayer
  }

  static loadVimeoId(vimeoId) {
    if (Application.videoPlayer.source == `https://vimeo.com/${vimeoId}`) return

    console.log('load vimeo id', vimeoId)
    Application.videoPlayer.source = {
      type: 'video',
      autoplay: true,
      sources: [{ src: vimeoId, provider: 'vimeo' }],
      vimeo: { playsinline: false },
    }
  }

  static useAutoFullscreen() {
    return true || Application.isMobileDevice() || screen.width < 1024
  }

}
