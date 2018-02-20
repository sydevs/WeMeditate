
var Music = {
  mood_filter: null,
  instrument_filters: [],
  song_list: null, // To be set on load

  load: function() {
    Music.song_list = $('.playlist-wrap .song-info')
    Music.song_list.children('a.song-title').each(Music._on_init_track)
    $('.mood__container a').on('click', Music._on_select_mood)
    $('.instrument__container a').on('click', Music._on_toggle_instrument)
    Music.song_list.children('a.song-title').on('click', Music._on_select_track)
    console.log(Music.song_list.children('a.song-title'))
  },

  _on_init_track: function() {
    var audio = new Audio(), element = $(this)

    $(audio).on("loadedmetadata", function() {
      element.siblings('.duration-time').text(Music.format_duration(audio.duration))
    })

    audio.src = this.href
  },

  _on_select_track: function() {
    console.log('selected', this)
    var image_url = $(this).data('image')
    var image_element = $('#music-player-image')

    if (image_url) {
      image_element.css('background-image', 'url(' + image_url + ')')
    } else {
      image_element.css('background-image', 'url(' + image_element.data('default') + ')')
    }
  },

  _on_select_mood: function() {
    Music.set_mood_filter($(this).data('filter'))
  },

  _on_toggle_instrument: function() {
    Music.toggle_instrument_filter($(this).data('filter'))
  },

  set_mood_filter: function(filter) {
    Music.mood_filter = filter
    Music.reset_filtered_visibility()
  },

  toggle_instrument_filter: function(filter) {
    if (Music.instrument_filters.includes(filter)) {
      const index = Music.instrument_filters.indexOf(filter)
      if (index !== -1) Music.instrument_filters.splice(index, 1)
      
      if (Music.instrument_filters.length == 0) {
        Music.reset_filtered_visibility()
      } else {
        Music.song_list.each(function() {
          var element = $(this)
          if (!element.hasClass(filter)) {
            element.toggle(Music.recalculate_filtered_visibility(element))
          }
        })
      }
    } else {
      Music.instrument_filters.push(filter)
      
      Music.song_list.each(function() {
        var element = $(this)
        if (!element.hasClass(filter)) {
          element.hide()
        }
      })
    }
  },

  reset_filtered_visibility: function() {
    Music.song_list.each(function() {
      var element = $(this)
      element.toggle(Music.recalculate_filtered_visibility(element))
    })
  },

  recalculate_filtered_visibility: function(element) {
    if (Music.mood_filter != null && !element.hasClass(Music.mood_filter)) {
      return false
    }
    
    for (var i = Music.instrument_filters.length; i--; i >= 0) {
      if (!element.hasClass(Music.instrument_filters[i])) {
        return false
      }
    }

    return true
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
