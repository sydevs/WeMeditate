import $ from 'jquery'
import { shuffleArray, show, toggle, hasCommonItems } from '../util'
import { Howl, Howler } from 'howler'

export default class Audio {

  constructor(element, _index) {
    this.container = element
    this.tracks = JSON.parse(element.dataset.tracks)
    this.trackIndex = 0
    this.shuffledPlaylist = null
    this.filters = []
    this.filteredPlaylist = Array.from(this.tracks.keys())

    var attributes = [
      'filter', 'icon',
      'title', 'artists', 'image',
      'play', 'prev', 'next', 'shuffle',
      'progress', 'timer', 'duration',
      'volume'
    ]

    this.elements = {}
    this.elements.tracks = this.container.querySelector('.audio__tracks__list')
    attributes.forEach(attribute => {
      //this.elements[attribute] = this.container.querySelector(`[data-attribute="${attribute}"]`)
      this.elements[`$${attribute}`] = $(element).find(`[data-attribute="${attribute}"]`)
    })

    this.elements.$play.click(event => {
      if (event.target.tagName === 'A') return
      if (event.currentTarget.dataset.trackIndex) {
        this.skipTo(parseInt(event.currentTarget.dataset.trackIndex))
      } else {
        this.toggle()
      }
    })

    this.elements.$prev.click(() => this.skip('prev'))
    this.elements.$next.click(() => this.skip('next'))
    this.elements.$shuffle.click(() => this.shuffle())
    this.elements.$progress.click((event) => this.seek(event.currentTarget.value))
    this.elements.$volume.click((event) => this.volume(event.currentTarget.value))
    this.elements.$filter.click(() => this.filter(event.currentTarget.dataset.filter, event.currentTarget.innerText))
  }

  unload() {
    this.stop()
  }

  onPlay(sound) {
    this.elements.$duration.text(this.formatTime(Math.round(sound.duration())))
    requestAnimationFrame(this.step.bind(this))
  }

  onLoad(sound) {
    this.elements.$duration.text(this.formatTime(Math.round(sound.duration())))
    this.container.dataset.state = 'playing'
  }

  onSeek() {
    requestAnimationFrame(this.step.bind(this))
  }

  onEnd() {
    this.skip('next')
  }

  toggle() {
    let sound = this.tracks[this.trackIndex].howl

    if (sound && sound.playing()) {
      this.pause()
    } else {
      this.play()
    }
  }

  play(index) {
    let trackIndex = (typeof index === 'number' ? index : this.trackIndex)
    let track = this.tracks[trackIndex]
    
    if (!track.howl) {
      track.howl = new Howl({
        src: [track.file],
        html5: true,
        onplay: () => this.onPlay(track.howl),
        onload: () => this.onLoad(track.howl),
        onend: () => this.onEnd(),
        onseek: () => this.onSeek()
      })
    }
    
    let sound = track.howl
    sound.play()
    this.elements.$title.text(track.title)
    this.elements.$image.attr('src', track.image)

    if (track.artists) {
      let artistsHTML = track.artists.map(a => `<a href="${a[1]}" target="_blank">${a[0]}</a>`)
      this.elements.$artists.html(artistsHTML.join(', '))
    }

    this.container.dataset.state = (sound.state() === 'loaded' ? 'playing' : 'loading')
    this.trackIndex = trackIndex

    if (this.elements.tracks) {
      let activeTrack = this.elements.tracks.querySelector('.audio__track--active')
      if (activeTrack) activeTrack.classList.remove('audio__track--active')
      this.elements.tracks.querySelector(`.audio__track[data-track-index="${trackIndex}"]`).classList.add('audio__track--active')
    }
  }

  pause() {
    let sound = this.tracks[this.trackIndex].howl
    sound.pause()
    this.container.dataset.state = 'paused'
  }

  stop() {
    if (this.tracks[this.trackIndex].howl) {
      this.tracks[this.trackIndex].howl.stop()
    }

    this.elements.$progress.val(0)
  }

  skip(direction) {
    let index = this.findTrackIndex(direction)
    this.skipTo(index)
  }

  skipTo(index) {
    this.stop()
    this.play(index)
  }

  volume(val) {
    Howler.volume(val)
    this.elements.$volume.val(val)
  }

  seek(percent) {
    let sound = this.tracks[this.trackIndex].howl

    if (sound.playing()) {
      sound.seek(sound.duration() * percent)
    }
  }

  step() {
    var sound = this.tracks[this.trackIndex].howl
    var seekPosition = sound.seek() || 0
    this.elements.$timer.text(this.formatTime(Math.round(seekPosition)))
    this.elements.$progress.val((seekPosition / sound.duration()) || 0)

    // If the sound is still playing, continue stepping.
    if (sound.playing()) {
      requestAnimationFrame(this.step.bind(this))
    }
  }

  shuffle() {
    if (this.shuffledPlaylist) {
      this.shuffledPlaylist = null
    } else {
      this.shuffledPlaylist = shuffleArray(this.filteredPlaylist)
    }

    this.container.dataset.shuffle = Boolean(this.shuffledPlaylist)
  }

  filter(id) {
    this.filters = this.filters.indexOf(id) >= 0 ? [] : [id]
    this.setupPlaylist(Boolean(this.shuffledPlaylist))
    /* This block of code would allow multiple filters to be selected simultaneously.
    let existingIndex = this.filters.indexOf(id)
    if (existingIndex >= 0) {
      this.filters.splice(existingIndex, 1)
    } else {
      this.filters.push(id)
    }
    */

    if (this.filters.length > 0) {
      // Check if the current track is in new filter
      if (!this.filteredPlaylist.includes(this.trackIndex)) {
        this.skipTo(this.findTrackIndex('first'))
      }

      // Hide any tracks which belong to another filter
      for (let i = 0; i < this.elements.tracks.childElementCount; i++) {
        const element = this.elements.tracks.children[i]
        let show = false
        let filterBy = element.dataset.filterBy.split(' ')
        for (let j = 0; j < filterBy.length; j++) {
          if (this.filters.includes(filterBy[j])) {
            show = true
            break
          }
        }

        toggle(element, show, 'inline-block')
      }

      // Set the filter as active
      let filters = this.filters
      this.elements.$filter.each(function() {
        this.classList.toggle('audio__filter--active', filters.includes(this.dataset.filter))
      })

      // Show the corresponding filter icon
      this.elements.$icon.each(function() {
        toggle(this, filters.includes(this.dataset.filter), 'inline-block')
      })
    } else {
      for (let i = 0; i < this.elements.tracks.childElementCount; i++) {
        show(this.elements.tracks.children[i], 'inline-block')
      }

      this.elements.$filter.removeClass('audio__filter--active')
      this.elements.$icon.hide()
    }
  }

  setupPlaylist(shuffle = false) {
    if (this.filters.length > 0) {
      this.filteredPlaylist = []
      for (let i = 0; i < this.tracks.length; i++) {
        if (hasCommonItems(this.filters, this.tracks[i].filters)) {
          this.filteredPlaylist.push(i)
        }
      }
    } else {
      this.filteredPlaylist = Array.from(Array(this.tracks.length).keys())
    }

    if (shuffle) {
      this.shuffledPlaylist = shuffleArray(this.filteredPlaylist)
    }
  }

  findTrackIndex(type) {
    let order = this.shuffledPlaylist ? this.shuffledPlaylist : this.filteredPlaylist
    let index = order.indexOf(this.trackIndex)

    if (type === 'first') {
      return order[0]
    } else if (type === 'prev') {
      index -= 1
      if (index < 0) {
        index = order.length - 1
      }
    } else {
      index += 1
      if (index >= order.length) {
        index = 0
      }
    }

    return order[index]
  }

  formatTime(secs) {
    var minutes = Math.floor(secs / 60) || 0
    var seconds = (secs - minutes * 60) || 0
    return minutes + ':' + (seconds < 10 ? '0' : '') + seconds
  }
}
