
var Music = {
  // These variables will be set on load
  player: null,
  player_title: null,
  player_artist: null,

  list: null,
  track_selectors: null,

  cover: null,
  default_cover_url: null,
  filter_icons: null,

  load: function() {
    var player = $('audio#player')
    Music.player = new Plyr('audio#player', player.data('controls'))
    Music.player_title = $('#track-player-title')
    Music.player_artist = $('#track-player-artist')

    Music.list = $('.playlist #grid')
    Music.track_selectors = Music.list.find('.track > a.info')
    Music.track_selectors.each(Music._init_track)
    Music.track_selectors.on('click', Music._on_select_track)

    Music.cover = $('#track-cover')
    Music.default_cover_url = Music.cover.attr('href')

    Music.filter_icons = $('#selected-filter-icons')

    $('.instrument.filters > a').on('mouseup', Music._on_clicked_instrument_filter)
  },

  _init_track: function() {
    var info = $(this)
    var audio = new Audio()

    $(audio).on('loadedmetadata', function() {
      info.siblings('.duration').text(Music.format_duration(audio.duration))
    })

    audio.src = this.href
  },

  _on_clicked_instrument_filter: function() {
    var element = $(this)
    var klass = 'for-'+this.dataset.filter.slice(1)

    if (element.hasClass('active')) {
      Music.filter_icons.children('.'+klass).remove()
    } else {
      var icon = $(element.html()).addClass(klass)
      Music.filter_icons.append(icon)
    }
  },

  _on_select_track: function(e) {
    var image_url = this.dataset.artistImage
    Music.player_title.text(this.textContent)
    Music.player_artist.text(this.dataset.artistName)
    Music.player_artist.attr('href', this.dataset.artistUrl)

    if (!image_url) {
      image_url = Music.default_cover_url
    }

    Music.cover.attr('src', image_url)
    Music.player.source = {
      type: 'audio',
      title: this.textContent,
      sources: [
        { src: this.href, type: 'audio/mp3' },
      ]
    }

    Music.player.play()
    e.preventDefault()
  },

  format_duration: function(seconds) {
    var sec_num = parseInt(seconds, 10) // don't forget the second param
    var hours   = Math.floor(sec_num / 3600)
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60)
    var seconds = sec_num - (hours * 3600) - (minutes * 60)

    if (hours   < 10) {hours   = "0"+hours}
    if (minutes < 10) {minutes = "0"+minutes}
    if (seconds < 10) {seconds = "0"+seconds}

    if (hours > 0)
      return hours+':'+minutes+':'+seconds
    else
    return minutes+':'+seconds
  },
}

$(document).on('turbolinks:load', function() { Music.load() })
console.log('loading Music.js')
