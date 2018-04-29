
var Carousel = {
  default_options: {
    margin: 60,
    navText: ['<i class="left arrow icon"></i>', '<i class="right arrow icon"></i>'],
  },

  video_options: {
    center: true,
    loop: true,
    nav: true,
    dots: false,
    //autoWidth: true,
    smartSpeed: 700,
    responsiveClass: true,
    responsive: {
      0: { items: 1 },
      768: { items: 1 },
      992: { items: 1 },
      1400: { items: 3 }
    }
  },

  load: function() {
    console.log('loading Carousel.js')

    $.extend(Carousel.video_options, Carousel.default_options)

    $('.carousel').each(function() {
      $carousel = $(this)
      if ($carousel.hasClass('video')) {
        $carousel.owlCarousel(Carousel.video_options)
      } else {
        $carousel.owlCarousel(Carousel.default_options)
      }
    })
  },
}

$(document).on('turbolinks:load', function() { Carousel.load() })
