/** POPOUTS
 * When a user selects an image or video, the media should popout into a lightbox where the user can see it close up.
 * This file implements that with the help of the magnificPopup library
 */

const Popout = {
  // These variables will be set on load
  video_player: null,

  load() {
    console.log('loading Popout.js')
    let player = $('#video-player')

    // Initialize the common video player that is used for all popouts
    Popout.video_player = new Plyr('#video-player', player.data('controls'))

    // When a video popout is opened it should play the video as soon as it can.
    Popout.video_player.on('canplay', function() {
      Popout.video_player.play()
    })

    // Initialize generic popouts.
    $('a.popout:not(.gallery)').magnificPopup()
    $('a.gallery.popout').magnificPopup({
      gallery: { enabled: true },
    })

    Popout.init_popouts($('body'))

    // In the future, carousels might support popouts.
    /*$('.carousel a.video.button').magnificPopup({
      key: 'video',
      gallery: { enabled: true },
      callbacks: { open: Popout._on_video_open }
    })*/
  },

  // This will allow us to initialize popouts withing a specific context, this is useful when dynamic content is added to the page.
  init_popouts($context) {
    // Initialize all video buttons that specific a source for the video.
    $('.video-button[data-mfp-src]', $context).magnificPopup({
      key: 'video',
      callbacks: { open: Popout._on_video_open }
    })
  },

  // Triggered when a video popout is opened
  // This allows us to set up the video player.
  _on_video_open() {
    var element = this.ev[0]
    Popout.video_player.source = {
      type: 'video',
      sources: [
        { src: element.href, type: 'video/mp4' },
      ]
    }
  },
}

$(document).on('turbolinks:load', () => { Popout.load() })
