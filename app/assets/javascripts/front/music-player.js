
class MusicPlayer {

  constructor(element) {
    const audioPlayer = element.querySelector('audio')
    const controls = audioPlayer.querySelector('data-controls').innerText

    this.container = element
    this.player = new Plyr(audioPlayer, { controls, invertTime: true })
    this.selectionContainer = element.querySelector('.player__selection')
    this.sidetext = element.querySelector('.player__sidetext')
    this.icons = element.querySelector('.player__icons')
    this.playlist = JSON.parse(element.dataset.playlist)
    this.mini = element.classList.contains('player--mini')
    this.currentTrackIndex = 0

    $(element).on('click', '[data-plyr="skip-back"]', () => this.selectPreviousTrack())
    $(element).on('click', '[data-plyr="skip-forward"]', () => this.selectNextTrack())
    this.player.on('ended', () => this.selectNextTrack())

    this.selectionTitle = this.container.querySelector('.player__selection__title')
    this.selectionArtist = this.container.querySelector('.player__selection__artist')
    this.filters = {}

    if (!this.mini) this.initFullPlayer()
  }

  unload() {
    this.player.destroy()
  }

  initFullPlayer() {
    this.coverImage = this.container.querySelector('.player__cover__img')
    this.playlistContainer = document.getElementById('music-player-playlist')
    for (let i = 0; i < this.playlistContainer.childElementCount; i++) {
      this.initTrack(this.playlistContainer.children[i])
    }

    this.filterContainers = {}
    //this.initFilterGroup('mood')
    this.initFilterGroup('instrument')

    this.defaultCoverJpgSrcset = this.coverImage.getAttribute('data-srcset')
    this.defaultCoverWebpSrcset = this.coverImage.previousSibling.getAttribute('data-srcset')
  }

  initFilterGroup(type) {
    const container = document.getElementById(`music-player-${type}-filters`)
    for (let i = 0; i < container.childElementCount; i++) {
      container.children[i].addEventListener('click', event => this.setFilter(type, event.currentTarget))
    }

    this.filterContainers[type] = container
  }

  initTrack(element) {
    var audio = new Audio()

    $(audio).on('loadedmetadata', function() {
      element.querySelector('.player__item__duration').innerText = MusicPlayer.formatDuration(audio.duration)
    })

    element.querySelector('.player__item__label').addEventListener('click', event => {
      const index = event.currentTarget.parentNode.dataset.index
      this.selectTrack(this.playlist[index])
      event.preventDefault()
      return false
    })

    audio.src = this.playlist[element.dataset.index].src
  }

  setFilter(type, element) {
    const activeButton = this.filterContainers[type].querySelector('.button--active')
    if (activeButton) activeButton.classList.remove('button--active')

    const filter = parseInt(element.dataset.filter)
    if (this.filters[type] == filter) {
      this.filters[type] = null
      return
    } else {
      this.filters[type] = filter
    }

    if (type == 'instrument') {
      this.sidetext.innerText = element.innerText
    }

    this.icons.innerHTML = ''
    this.icons.appendChild(element.querySelector('svg').cloneNode(true))

    element.classList.add('button--active')
    this.applyFilters()
  }

  applyFilters() {
    for (let i = 0; i < this.playlistContainer.childElementCount; i++) {
      const element = this.playlistContainer.children[i]
      const data = this.playlist[element.dataset.index]
      $(element).toggle(this.isTrackAvailable(data))
    }

    if (!(this.player.playing && this.isTrackAvailable(this.playlist[this.currentTrackIndex]))) {
      this.selectNextTrack(true)
    }

    zenscroll.to(this.container)
  }

  isTrackAvailable(data) {
    let available = true

    for (let key in this.filters) {
      available = available && this.filters[key] == null || data[`${key}_filters`].includes(this.filters[key])
    }

    return available
  }

  renderArtists(artists) {
    let html = []
    artists.forEach(artist => {
      html.push(`<a href="${artist.url}">${artist.name}</a>`)
    })

    return html.join(", ")
  }

  selectTrack(data) {
    this.selectionTitle.innerText = data.name
    this.selectionArtist.innerHTML = this.renderArtists(data.artists)

    this.player.source = {
      type: 'audio',
      title: data.name,
      sources: [
        { src: data.src, type: 'audio/mp3' },
      ]
    }

    this.player.play()

    if (!this.mini) {
      this.setCoverImage(pickRandom(data.artists).image_srcset)
      this.playlistContainer.children[this.currentTrackIndex].classList.remove('player__item--active')
      this.currentTrackIndex = data.index
      this.playlistContainer.children[this.currentTrackIndex].classList.add('player__item--active')
    } else {
      this.currentTrackIndex = data.index
    }
  }

  selectPreviousTrack() {
    let index = this.currentTrackIndex - 1

    while (true) {
      if (index < 0) {
        index = this.playlist.length - 1
      } else if (this.isTrackAvailable(this.playlist[index])) {
        break
      } else {
        index -= 1
      }
    }

    this.selectTrack(this.playlist[index])
  }

  selectNextTrack(reset = false) {
    let index = this.currentTrackIndex + 1
    if (reset) index = 0

    while (true) {
      if (index >= this.playlist.length) {
        index = 0
      } else if (this.isTrackAvailable(this.playlist[index])) {
        break
      } else {
        index += 1
      }
    }

    this.selectTrack(this.playlist[index])
  }

  setCoverImage(srcset) {
    if (srcset) {
      this.coverImage.setAttribute('srcset', srcset.jpg)
      this.coverImage.previousSibling.setAttribute('srcset', srcset.webp)
    } else {
      this.coverImage.setAttribute('srcset', this.defaultCoverJpgSrcset)
      this.coverImage.previousSibling.setAttribute('srcset', this.defaultCoverWebpSrcset)
    }
  }

  static formatDuration(seconds) {
    var secNum  = parseInt(seconds, 10) // don't forget the second param
    var hours   = Math.floor(secNum / 3600)
    var minutes = Math.floor((secNum - (hours * 3600)) / 60)
    var seconds = secNum - (hours * 3600) - (minutes * 60)

    if (seconds < 10) { seconds = '0'+seconds }

    if (hours > 0) {
      if (hours   < 10) { hours   = '0'+hours }
      if (minutes < 10) { minutes = '0'+minutes }

      return `${hours}:${minutes}:${seconds}`
    } else {
      return `${minutes}:${seconds}`
    }
  }

}
