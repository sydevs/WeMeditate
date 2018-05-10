
var Carousel = {
  default_options: {
    centerPadding: '60px',
    slidesToShow: 3,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          arrows: true,
          slidesToShow: 1,
          centerPadding: '40px',
        }
      },
      {
        breakpoint: 480,
        settings: {
          arrows: true,
          slidesToShow: 1,
          centerPadding: '40px',
        }
      }
    ]
  },

  video_options: {
    centerMode: true,
    slidesToShow: 1,
  },

  columns_options: {},

  contacts_options: {},

  load: function() {
    console.log('loading Carousel.js')

    $.extend(Carousel.video_options, Carousel.default_options)
    $.extend(Carousel.columns_options, Carousel.default_options)
    $.extend(Carousel.contacts_options, Carousel.default_options)

    $('.carousel').each(function() {
      $carousel = $(this)
      style = $carousel.data('style')

      if (style == 'video') {
        $carousel.slick(Carousel.video_options)
      } else if (style == 'columns') {
        $carousel.slick(Carousel.columns_options)
      } else if (style == 'contacts') {
        $carousel.slick(Carousel.contacts_options)
      } else {
        $carousel.slick(Carousel.default_options)
      }
    })

    $('.carousel').slick(Carousel.options)
  },
}

$(document).on('turbolinks:load', function() { Carousel.load() })
