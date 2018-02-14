
$(document).on('turbolinks:load', function() {
  console.log('loading video.js')

  //  Plyr Controls
  var controls = [
    "<button type='button' data-plyr='play' class='plyr__play-large' aria-label='Play'><svg viewBox=\"0 0 105 105\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"m0 0h105v105h-105z\" fill=\"#c5e0dc\"/><path d=\"m48.67 64.49v-23.76l11.14 11.88z\" fill=\"#fff\"/></svg><span class='plyr__sr-only'>Play</span></button>",
    "<div class='plyr__controls'>",
    "<button type='button' data-plyr='play'>",
    "<svg viewBox=\"0 0 11 22\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"m0 0v22l11-11z\" fill=\"#fff\"/></svg>",
    "<span class='plyr__sr-only'>Play</span>",
    "</button>",
    "<button type='button' data-plyr='pause'>",
    "<svg height=\"18\" viewBox=\"0 0 10 18\" width=\"10\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#fff\"><path d=\"m0 0h1v18h-1z\"/><path d=\"m9 0h1v18h-1z\"/></g></svg>",
    "<span class='plyr__sr-only'>Pause</span>",
    "</button>",
    "<span class='plyr__progress'>",
    "<label for='seek{id}' class='plyr__sr-only'>Seek</label>",
    "<input id='seek{id}' class='plyr__progress--seek' type='range' min='0' max='100' step='0.1' value='0' data-plyr='seek'>",
    "<progress class='plyr__progress--played' max='100' value='0' role='presentation'></progress>",
    "<progress class='plyr__progress--buffer' max='100' value='0'>",
    "<span>0</span>% buffered",
    "</progress>",
    "<span class='plyr__tooltip'>00:00</span>",
    "</span>",
    "<span class='plyr__time'>",
    "<span class='plyr__sr-only'>Current time</span>",
    "<span class='plyr__time--current'>00:00</span>",
    "</span>",
    "<button type='button' data-plyr='mute'>",
    "<svg class='icon--muted' enable-background=\"new 0 0 17 19.8\" viewBox=\"0 0 17 19.8\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"m0 5.9v8.1h3.3l7.4 5.9v-19.9l-7 5.9zm1 7.1v-6.1h2.1v6.1zm8.7 4.8-5.6-4.5v-6.4l5.6-4.7z\" fill=\"#fff\"/></svg>",
    "<svg viewBox=\"0 0 17 19.83\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#fff\"><path d=\"m12.92 7.28h1v5.32h-1z\"/><path d=\"m16 5.06h1v9.75h-1z\"/><path d=\"m10.5 15v8.09h3.32l7.4 5.85v-19.85l-7 5.89zm1 7.09v-6.09h2.1v6.09zm8.72 4.78-5.62-4.46v-6.41l5.61-4.72z\" transform=\"translate(-10.5 -9.09)\"/></g></svg>",
    "<span class='plyr__sr-only'>Toggle Mute</span>",
    "</button>",
    "<span class='plyr__volume'>",
    "<label for='volume{id}' class='plyr__sr-only'>Volume</label>",
    "<input id='volume{id}' class='plyr__volume--input' type='range' min='0' max='10' value='5' data-plyr='volume'>",
    "<progress class='plyr__volume--display' max='10' value='0' role='presentation'></progress>",
    "</span>",
    "<button type='button' data-plyr='fullscreen'>",
    "<svg class='icon--exit-fullscreen' viewBox=\"0 0 18 18\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#fff\"><path d=\"m4.5 4.5h-4.5v-1h3.5v-3.5h1z\"/><path d=\"m4.5 18h-1v-3.5h-3.5v-1h4.5z\"/><path d=\"m14.5 18h-1v-4.5h4.5v1h-3.5z\"/><path d=\"m18 4.5h-4.5v-4.5h1v3.5h3.5z\"/></g></svg>",
    "<svg height=\"18\" viewBox=\"0 0 18 18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"none\" stroke=\"#fff\"><path d=\"m5 1h-4v4\"/><path d=\"m1 13v4h4\"/><path d=\"m13 17h4v-4\"/><path d=\"m17 5v-4h-4\"/></g></svg>",
    "<span class='plyr__sr-only'>Toggle Fullscreen</span>",
    "</button>",
    "</div>"].join("");

  // Setup the player
  plyr.setup('video', {
    html: controls
  });

  //  Init Video Popup
  var videoPoster, videoSource, $videoContainer, vid;
  $videoContainer = $('#video-popup video');
  vid = document.getElementById("#custom-video");

  $('.video-link').on('click', function () {
    $videoContainer.attr('poster', $(this).data('poster'));
    $videoContainer.find('source').attr('src', $(this).data('source'));
    $('.plyr-video-title').text($(this).data('title'));
    vid.load();
  });

  $('.popup-with-zoom-anim').magnificPopup({
    type: 'inline',
    fixedContentPos: true,
    fixedBgPos: true,
    overflowY: 'auto',
    closeBtnInside: true,
    preloader: false,
    midClick: true,
    removalDelay: 300,
    mainClass: 'my-mfp-zoom-in',
    callbacks: {
      close: function () {
        vid.currentTime = 0;
      }
    }
  });

  $('.plyr--video .plyr__controls button[data-plyr="pause"]').after('<span class="plyr-video-title"><span');
})
