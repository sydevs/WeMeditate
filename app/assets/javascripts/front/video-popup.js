
class VideoPopup {

  constructor(element, index) {
    this.popout = $(element).magnificPopup({
      key: 'video',
      callbacks: {
        open: function() {
          VideoPopup.loadVimeoId(this.ev[0].dataset.id)

          if (VideoPopup.useAutoFullscreen()) {
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

    if (VideoPopup.useAutoFullscreen()) {
      videoPlayer.on('exitfullscreen', () => $.magnificPopup.close())
    }

    return videoPlayer
  }

  static loadVimeoId(vimeoId) {
    if (Application.videoPlayer.source == `https://vimeo.com/${vimeoId}`) return

    Application.videoPlayer.source = {
      type: 'video',
      autoplay: true,
      sources: [{ src: vimeoId, provider: 'vimeo' }],
      vimeo: { playsinline: false },
    }
  }

  static useAutoFullscreen() {
    return Application.isMobileDevice || screen.width < 1024
  }

}
