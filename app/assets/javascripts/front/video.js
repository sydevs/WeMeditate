
class Video {

  constructor(element) {
    this.popout = $(element).magnificPopup({
      key: 'video',
      callbacks: {
        open: function() { Video.openPlayer(this.ev[0]) },
      },
    })
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
      sources: [{ src: element.dataset.id, provider: 'vimeo' }]
    }
  }

}
