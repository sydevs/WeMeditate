
var Popout = {
  // These variables will be set on load
  video_player: null,

  load: function() {
    var player = $('#video-player')
    Popout.video_player = new Plyr('#video-player', player.data('controls'))
    Popout.video_player.on('canplay', function() {
      Popout.video_player.play()
    })

    $('a.popout:not(.gallery)').magnificPopup()
    $('a.gallery.popout').magnificPopup({
      gallery: { enabled: true },
    })

    $('a.video.button').magnificPopup({
      key: 'video',
      callbacks: {
        open: function() {
          var element = this.ev[0]
          Popout.video_player.source = {
            type: 'video',
            sources: [
              { src: element.href, type: 'video/mp4' },
            ]
          }
        },
      }
    })
  },
}

$(document).on('turbolinks:load', function() { Popout.load() })
console.log('loading Popout.js')
