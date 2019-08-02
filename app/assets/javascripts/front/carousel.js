
class Carousel {

  static loadTranslations() {
    $.extend(true, $.magnificPopup.defaults, {
      tClose: translate['popup']['close'], // Alt text on close button
      tLoading: translate['popup']['loading'], // Text that is displayed during loading. Can contain %curr% and %total% keys
      gallery: {
        tPrev: translate['popup']['prev'], // Alt text on left arrow
        tNext: translate['popup']['next'], // Alt text on right arrow
        tCounter: translate['popup']['counter'], // Markup for "1 of 7" counter
      },
      image: {
        tError: translate['popup']['image_error'], // Error message when image could not be loaded
      },
      ajax: {
        tError: translate['popup']['ajax_error'], // Error message when ajax request failed
      }
    })
  }

  constructor(element) {
    const $element = $(element)
    this.container = element
    this.style = element.dataset.style || 'default'

    if (this.style == 'columns') {
      $element.on('beforeChange', (_event, slick, _currentSlide, nextSlide) => this.onSelectSlide(slick, nextSlide))
      $element.on('init', (_event, slick) => this.updateArrowText(slick, slick.currentSlide))
    }

    $element.slick(CarouselStyles[this.style])
  }

  unload() {
    $(this.container).slick('unslick')
  }

  onSelectSlide(slick, currentSlide) {
    this.updateArrowText(slick, currentSlide)
    zenscroll.to(this.container)
  }
  
  updateArrowText(slick, currentSlide) {
    const prevArrow = this.container.querySelector('.slick-prev')
    const nextArrow = this.container.querySelector('.slick-next')

    if (prevArrow) {
      const prevSlide = this.getSlide(slick, currentSlide - 1)
      prevArrow.innerText = prevSlide.querySelector('.content__structured__title').innerText
    }

    if (nextArrow) {
      const nextSlide = this.getSlide(slick, currentSlide + 1)
      nextArrow.innerText = nextSlide.querySelector('.content__structured__title').innerText
    }
  }

  getSlide(slick, index) {
    return slick.$slides.get(index % slick.slideCount)
  }

}

CarouselStyles = {
  default: {},

  columns: {
    centerPadding: '6%',
    slidesToShow: 3,
    arrows: false,
    responsive: [
      {
        breakpoint: 920,
        settings: {
          slidesToShow: 1,
          initialSlide: 1,
          centerPadding: '0',
          dots: true,
          arrows: true,
        }
      }
    ]
  },

  video: {
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

  meditations: {
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
}
