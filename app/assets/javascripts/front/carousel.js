
/** CAROUSEL
 * A carousel is a kind of slideshow that displays one or more elements at a time,
 * and then lets you swipe (or press an arrow button to see the rest).
 * The website also sometimes uses this to collapse columns of content for mobile views.
 *
 * Our implementation is created using the Slick library.
 * So this file mainly just defines configuration objects, and then passes them to Slick.
 */

const Carousel = {
  // Various carousels have different configurations, this is the default.
  default_options: {
    centerPadding: '6%',
    slidesToShow: 3,
    responsive: [
      {
        breakpoint: 992,
        settings: {
          arrows: true,
          slidesToShow: 1,
          centerPadding: '0',
        }
      },
      {
        breakpoint: 640,
        settings: {
          arrows: true,
          slidesToShow: 1,
        }
      }
    ]
  },

  // Configuration for a video-only carousel
  video_options: {
    centerPadding: '7%',
    centerMode: true,
    slidesToShow: 1,
    responsive: [
      {
        breakpoint: 1200,
        settings: {
          arrows: true,
          slidesToShow: 1,
          centerPadding: '0',
        }
      },
      {
        breakpoint: 640,
        settings: {
          arrows: true,
          centerMode: false,
          slidesToShow: 1,
        }
      }
    ]
  },

  // Configuration for the "program venues" carousel.
  venues_options: {
    centerPadding: '60px',
    slidesToShow: 1,
  },

  // Configuration for the "featured meditations" carousel.
  meditations_options: {
    dots: true,
    slidesToShow: 3,
    responsive: [
      {
        breakpoint: 740,
        settings: {
          arrows: true,
          slidesToShow: 1,
        }
      }
    ]
  },

  // Called when turbolinks loads the page
  load() {
    console.log('loading Carousel.js')

    $('.carousel').each(function() {
      $carousel = $(this)

      switch ($carousel.data('style')) {
        case 'video':
          $carousel.slick(Carousel.video_options)
          break
        case 'venues':
          $carousel.slick(Carousel.venues_options)
          break
        case 'meditations':
          $carousel.slick(Carousel.meditations_options)
          break
        default:
          $carousel.slick(Carousel.default_options)
          break
      }
    })
  },
}

$(document).on('turbolinks:load', () => { Carousel.load() })
