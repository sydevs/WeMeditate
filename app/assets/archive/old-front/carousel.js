
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
    arrows: false,
    responsive: [
      {
        breakpoint: 920,
        settings: {
          slidesToShow: 1,
          centerPadding: '0',
          dots: true,
        }
      }
    ]
  },

  // Configuration for a video-only carousel
  video_options: {
    centerMode: true,
    centerPadding: '24%',
    slidesToShow: 1,
    responsive: [
      {
        breakpoint: 920,
        settings: {
          slidesToShow: 1,
          centerPadding: '0',
        }
      },
      {
        breakpoint: 760,
        settings: {
          slidesToShow: 1,
          centerPadding: '0',
          arrows: false,
          dots: true,
        }
      },
    ]
  },

  // Configuration for the "featured meditations" carousel.
  meditations_options: {
    slidesToShow: 3,
    arrows: false,
    responsive: [
      {
        breakpoint: 760,
        settings: {
          slidesToShow: 1,
          dots: true,
        }
      },
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
        case 'meditations':
          $carousel.slick(Carousel.meditations_options)
          break
        default:
          $carousel.slick(Carousel.default_options)
          /*if ($(document.body).hasClass('subtle_system_nodes-show')) {
            $carousel.slick('slickGoTo', 1, false)
          }*/
          break
      }
    })
  },
}

$(document).on('turbolinks:load', () => { Carousel.load() })
