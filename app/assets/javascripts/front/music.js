
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
    console.log('loading Music.js');
    var player = $('audio#player');
    var seekTime = 10;
    var controls = `
<div class="plyr__controls">
    <button aria-label="Play, {title}" aria-pressed="false" class="plyr__control" data-plyr="play" type="button">
        <svg class="icon--pressed" role="presentation">
            <use xlink:href="#plyr-pause"></use>
        </svg>
        <svg class="icon--not-pressed" role="presentation">
            <use xlink:href="#plyr-play"></use>
        </svg> 
        <span class="label--pressed plyr__tooltip" role="tooltip">Pause</span><span
            class="label--not-pressed plyr__tooltip" role="tooltip">Play</span></button>
        <div class="plyr__progress"><label class="plyr__sr-only" for="plyr-seek-{id}"> Seek</label>
        <input data-plyr="seek" id="plyr-seek-{id}" max="100" min="0" step="0.01" type="range" value="0"/>
        <progress class="plyr__progress--buffer" max="100" min="0" value="0"> % buffered</progress>
        <span class="plyr__tooltip" role="tooltip"> 00:00</span></div>    
        <span class="plyr__time--current">00:00</span>   
    <button class="plyr__control" data-plyr="rewind" type="button">
        <svg role="presentation">
            <use xlink:href="#plyr-rewind"></use>
        </svg>
        <span class="plyr__tooltip" role="tooltip">Rewind ${seekTime} secs</span></button>
    <button class="plyr__control" data-plyr="fast-forward" type="button">
        <svg role="presentation">
            <use xlink:href="#plyr-fast-forward"></use>
        </svg>
        <span class="plyr__tooltip" role="tooltip">Forward ${seekTime} secs</span></button>
    <button aria-label="Mute" aria-pressed="false" class="plyr__control" data-plyr="mute" type="button">
        <svg class="icon--pressed" role="presentation">
            <use xlink:href="#plyr-muted"></use>
        </svg>
        <svg class="icon--not-pressed" role="presentation">
            <use xlink:href="#plyr-volume"></use>
        </svg>
        <span class="label--pressed plyr__tooltip" role="tooltip"> Unmute</span><span
            class="label--not-pressed plyr__tooltip" role="tooltip"> Mute</span></button>
    <div class="plyr__volume">   
        <label class="plyr__sr-only" for="plyr-volume-{id}"> Volume</label>
        <input
            autocomplete="off" data-plyr="volume" id="plyr-volume-{id}" max="1" min="0" step="0.05" type="range"
            value="1"/></div>
    <button aria-label="Enable captions" aria-pressed="true" class="plyr__control" data-plyr="captions" type="button">
        <svg class="icon--pressed" role="presentation">
            <use xlink:href="#plyr-captions-on"></use>
        </svg>
        <svg class="icon--not-pressed" role="presentation">
            <use xlink:href="#plyr-captions-off"></use>
        </svg>
        <span class="label--pressed plyr__tooltip" role="tooltip"> Disable captions</span><span
            class="label--not-pressed plyr__tooltip" role="tooltip"> Enable captions</span></button>
    <button aria-label="Enter fullscreen" aria-pressed="false" class="plyr__control" data-plyr="fullscreen"
            type="button">
        <svg class="icon--pressed" role="presentation">
            <use xlink:href="#plyr-exit-fullscreen"></use>
        </svg>
        <svg class="icon--not-pressed" role="presentation">
            <use xlink:href="#plyr-enter-fullscreen"></use>
        </svg>
        <span class="label--pressed plyr__tooltip" role="tooltip"> Exit fullscreen</span><span
            class="label--not-pressed plyr__tooltip" role="tooltip"> Enter fullscreen</span></button>
</div>`;
    Music.player = new Plyr(player, {
      controls,
      invertTime: false
    });


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
