
class Video {

  constructor(element) {
    this.popout = $(element).magnificPopup({
      key: 'video',
      callbacks: {
        open: function() { Video.openPlayer(this.ev[0]) },
      },
    })
  }

  static unloadPlayer() {
    Application.videoPlayer.destroy()
  }

  static loadPlayer(id) {
    const videoPlayerContainer = document.getElementById(id)
    const videoPlayer = new Plyr(videoPlayerContainer, videoPlayerContainer.dataset.controls)
    videoPlayerContainer.addEventListener('canplay', () => videoPlayer.play())
    return videoPlayer
  }

  static openPlayer(element) {
    Application.videoPlayer.source = {
      type: 'video',
      autoplay: true,
      sources: [{ src: element.dataset.id, provider: 'vimeo' }]
    }

    if (Video.useAutoFullscreen()) Application.videoPlayer.fullscreen.enter()
  }

  static useAutoFullscreen() {
    return Application.isMobileDevice() || screen.width < 1024
  }

}
