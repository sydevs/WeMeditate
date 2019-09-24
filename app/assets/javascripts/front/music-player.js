
// TODO: Implement responsive artist images

class MusicPlayer {

  constructor(element) {
    this.container = element
    this.activePlaylistId = null
    this.mini = element.classList.contains('amplitude--mini')
    this.sidetext = element.querySelector('.amplitude-sidetext')
    this.artistsList = element.querySelector('.amplitude-info-artists')
    this.playButton = element.querySelector('.amplitude-play-pause')
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
        loadstart: () => {
          this.playButton.classList.add('amplitude-loading')
        },
        loadeddata: () => {
          this.playButton.classList.remove('amplitude-loading')
        },
        song_change: () => {
          this.updateSongArtists()
        },
        play: () => {
          this.validateActivePlaylist()
        }
      }
    })
    
    if (!this.mini) this.initFullPlayer()
    this.updateSongArtists()
  }

  unload() {
    Amplitude.pause()
  }

  initFullPlayer() {
    const playlistButtons = this.container.querySelectorAll('.amplitude-playlist-button')
    for (let i = 0; i < playlistButtons.length; i++) {
      playlistButtons[i].addEventListener('click', event => this.togglePlaylist(event.currentTarget))
    }

    const artistLinks = this.container.querySelectorAll('.amplitude-song-artist > a')
    for (let i = 0; i < artistLinks.length; i++) {
      artistLinks[i].addEventListener('click', event => event.stopPropagation())
    }
  }

  togglePlaylist(playlistElement) {
    if (playlistElement.dataset.amplitudePlaylist == this.activePlaylistId) {
      this.container.classList.remove('amplitude-loading')
      Amplitude.playPlaylistSongAtIndex(0, '0')
      Amplitude.pause()
    }
  }

  updateSongArtists() {
    if (!this.artistsList) return
    const data = Amplitude.getActiveSongMetadata()

    let html = []	
    data.artists.forEach(artist => {	
      html.push(`<a href="${artist.url}" target="_blank">${artist.name}</a>`)
    })
    
    this.artistsList.innerHTML = html.join(", ")
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
