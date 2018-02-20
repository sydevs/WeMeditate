
$(document).on('turbolinks:load', function() {
  //  Chakras & Channels Trigger
  var currentItems = '', triggerItems = $('.trigger-item');

  triggerItems.on('mouseover', function () {
    $(currentItems).stop().fadeOut('slow').removeClass('active');
    var currentClass = $(this).data('class');
    currentItems = '.' + currentClass;
    setTimeout(function () {
      $(currentItems).stop().fadeIn('slow').addClass('active');
    }, 300)
  });

  if ($('main.page-chakras-channels').length) {
    if (window.matchMedia("(max-width: 460px)").matches) {
      triggerItems.on('touchstart', function () {
        setTimeout(function () {
          $('body,html').stop().animate({scrollTop: 400}, 1000);
        }, 300)
      })
    }
  }
  
  // Chakras Animation
  function svgAnimation() {
    var lineHeight = $('.yoga-line').outerHeight();
    TweenMax.to($('.yoga-line'), 2, {height: '100%'});
    var timer;
    timer = setInterval(function () {
      var lineHeightInterval = $('.yoga-line').height();
      $('.yoga-circle').each(function () {
        if ($('.yoga-line').outerHeight() !== lineHeight) {
          if (Math.round(lineHeightInterval) > Math.round($('.yoga-mask').outerHeight() - $(this).position().top)) {
            TweenMax.to($(this), .5, {opacity: 1});
          }
        }
      });
      if (lineHeightInterval > $('.yoga-mask').outerHeight()) clearInterval(timer);
    }, 1);
  }
})

var chakrasContainer = $('.chakra-desc__container');

function destroyChakrasSlider() {
  chakrasContainer.trigger('destroy.owl.carousel');
}

function initChakrasSlider() {
  chakrasContainer.owlCarousel({
    loop: true,
    margin: 10,
    responsiveClass: true,
    navText: ['<i class="icon-arrow-left"></i>', '<i class="icon-arrow-right"></i>'],
    responsive: {
      0: {
        items: 1,
        nav: true
      },
      1024: {
        items: 1,
        nav: true
      }
    }
  });
}
