
var Music = {
  // These variables will be set on load
  player: null,
  player_title: null,
  player_artist: null,
  mood_title: null,

  list: null,
  track_selectors: null,

  cover: null,
  default_cover_url: null,
  filter_icons: null,

  instrument_filters: null,
  mood_filters: null,

  load: function() {
    console.log('loading Music.js');
    var $player = $('audio#player');
    var controls = $player.find('data-controls').text();
    Music.player = new Plyr($player, {
      controls,
      invertTime: false
    });

    $('.player').on('click', '[data-plyr="skip-back"]', Music._on_select_prev)
    $('.player').on('click', '[data-plyr="skip-forward"]', Music._on_select_next)
    Music.player.on('ended', Music._on_select_next)

    Music.player_title = $('#track-player-title')
    Music.player_artist = $('#track-player-artist')
    Music.mood_title = $('#track-mood-title')
    Music.instrument_filters = $('.instrument.filters > a.filter')
    Music.mood_filters = $('.mood.filters > a.filter')

    Music.list = $('.playlist #grid')
    Music.track_selectors = Music.list.find('.track > a.info')
    Music.track_selectors.each(Music._init_track)
    Music.track_selectors.on('click', Music._on_select_track)

    Music.cover = $('#track-cover')
    Music.default_cover_url = Music.cover.attr('href')

    Music.filter_icons = $('#selected-filter-icons')

    Music.instrument_filters.on('mouseup', Music._on_clicked_instrument_filter)
    Music.mood_filters.on('mouseup', Music._on_clicked_mood_filter)
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

  _on_clicked_mood_filter: function() {
    if (Music.mood_title.text() == this.innerText) {
      Music.mood_title.text('')
    } else {
      Music.mood_title.text(this.innerText)
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

    Music.list.find('.track').removeClass('active')
    $(this).closest('.track').addClass('active')
    if (e != null) e.preventDefault()
  },

  _on_select_next: function() {
    console.log('attempt next')
    $next_track = Music.list.children('.active.track').nextAll('.track').first()
    if ($next_track.length == 0) {
      $next_track = Music.list.children('.track').first()
    }

    next_track_selector = $next_track.children('a.info')[0]
    console.log('next', next_track_selector)
    Music._on_select_track.call(next_track_selector)
  },

  _on_select_prev: function() {
    console.log('attempt previous')
    $prev_track = Music.list.children('.active.track').prevAll('.track').first()
    if ($prev_track.length == 0) {
      $prev_track = Music.list.children('.track').last()
    }

    prev_track_selector = $prev_track.children('a.info')[0]
    console.log('previous', prev_track_selector)
    Music._on_select_track.call(prev_track_selector)
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
