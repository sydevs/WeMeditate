
var Meditation = {
  // These variables will be set on load
  audio_player: null,

  load: function() {
    console.log('loading Meditation.js')
    var player = $('audio#audio-player')
    Meditation.audio_player = new Plyr('audio#audio-player', player.data('controls'))
  },
}

$(document).on('turbolinks:load', function() { Meditation.load() })
