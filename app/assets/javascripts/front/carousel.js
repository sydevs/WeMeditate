
class Carousel {

  constructor(element) {
    $(element).slick(CarouselStyles[element.dataset.style || 'default'])
  }

}

CarouselStyles = {
  default: {
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
