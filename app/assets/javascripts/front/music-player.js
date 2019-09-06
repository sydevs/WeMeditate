
class MusicPlayer {

  constructor(element) {
    this.container = element
    this.activePlaylistId = null
    this.mini = element.classList.contains('amplitude--mini')
    this.sidetext = element.querySelector('.amplitude-sidetext')
    const data = JSON.parse(element.dataset.tracks)
    this.playlists = data.playlists

    Amplitude.init({
      volume: 80,
      songs: data.songs,
      playlists: data.playlists,
      starting_playlist: 0,
      preload: this.mini ? 'none' : 'metadata',
      debug: true,
      callbacks: {
        play: () => this.validateActivePlaylist(),
      }
    })

    const playlistButtons = element.querySelectorAll('.amplitude-playlist-button')
    for (let i = 0; i < playlistButtons.length; i++) {
      playlistButtons[i].addEventListener('click', event => this.togglePlaylist(event.currentTarget))
    }
  }

  togglePlaylist(playlistElement) {
    if (playlistElement.dataset.amplitudePlaylist == this.activePlaylistId) {
      Amplitude.playPlaylistSongAtIndex(0, '0')
      Amplitude.pause()
    }
  }

  validateActivePlaylist() {
    if (this.mini) return
    const playlistId = Amplitude.getActivePlaylist()
    if (this.activePlaylistId == playlistId) return

    if (this.activePlaylistId == null) this.activePlaylistId = '0'
    this.setElementActive(this.activePlaylistId, 'playlist-button', false)
    this.setElementActive(this.activePlaylistId, 'playlist-container', false)

    this.activePlaylistId = playlistId
    this.setElementActive(playlistId, 'playlist-button', true)
    this.setElementActive(playlistId, 'playlist-container', true)

    if (this.sidetext) {
      this.sidetext.innerText = this.playlists[playlistId].title
    }
  }

  setElementActive(playlistId, elementClass, active) {
    const selector = `.amplitude-${elementClass}[data-amplitude-playlist="${playlistId}"]`
    const element = this.container.querySelector(selector)
    if (element) element.classList.toggle(`amplitude-active-${elementClass}`, active)
  }

}
