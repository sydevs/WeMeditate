
class Carousel {

  constructor(element) {
    const $element = $(element)
    this.container = element
    this.style = element.dataset.style || 'default'

    $element.on('init', (_event, slick) => {
      this.prevArrow = element.querySelector('.slick-prev')
      this.nextArrow = element.querySelector('.slick-next')
    })
  
    if (this.style == 'columns') {
      $element.on('beforeChange', (_event, slick, _currentSlide, nextSlide) => this.onSelectSlide(slick, nextSlide))
      $element.on('init', (_event, slick) => this.updateArrowText(slick, slick.currentSlide))
    }

    $element.slick(CarouselStyles[this.style])
  }

  onSelectSlide(slick, currentSlide) {
    this.updateArrowText(slick, currentSlide)
    zenscroll.to(this.container)
  }
  
  updateArrowText(slick, currentSlide) {
    const prevSlide = this.getSlide(slick, currentSlide - 1)
    this.prevArrow.innerText = prevSlide.querySelector('.content__structured__title').innerText

    const nextSlide = this.getSlide(slick, currentSlide + 1)
    this.nextArrow.innerText = nextSlide.querySelector('.content__structured__title').innerText    
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
