$(document).on('turbolinks:load', function() {
  console.log('loading common.js')

  // Read More
  $(".methods__container .item").slice(0, 2).show().css('display', 'flex');
  $(".btn__more-methods").on('click', function (e) {
    e.preventDefault();
    $(".methods__container .item:hidden").slice(0, 2).slideDown('slow').css('display', 'flex');
    if ($(".methods__container .item:hidden").length == 0) {
      $(".btn__more-methods").fadeOut('slow');
      $('.methods__container .item').removeClass('mb-150');
    }
    $('html,body').animate({
      scrollTop: $(this).offset().top
    }, 1500);
  });

  //  Full List
  $(".page-shri-mataji .article__item").slice(0, 3).show();
  $(".page-shri-mataji .loadmore").on('click', function (e) {
    e.preventDefault();
    $(".page-shri-mataji .article__item:hidden").slice(0, 6).fadeIn('slow');
    if ($(".methods__container .item:hidden").length == 0) {
      $(".page-shri-mataji .loadmore").fadeOut('slow');
    }
  });

  //  Tabs
  function tabsContainer() {
    $('.tab-content').hide();
    $('.tab-content:first').show();
    $('.tabs li:first').addClass('active');

    $('.tabs li').on('click', function (e) {
      e.preventDefault();
      $('.tabs li').removeClass('active');
      $(this).addClass('active');
      $('.tab-content').hide();

      var selectTab = $(this).find('a').attr('href');
      $(selectTab).fadeIn();

      if (window.matchMedia("(max-width: 460px)").matches) {
        $('body,html').animate({scrollTop: 0}, 1000);
      }
    });
  }

  tabsContainer();

  //  SVG img-parser
  $('img.svg').each(function () {
    var $img = jQuery(this);
    var imgID = $img.attr('id');
    var imgClass = $img.attr('class');
    var imgURL = $img.attr('src');
    jQuery.get(imgURL, function (data) {
      // Get the SVG tag, ignore the rest
      var $svg = jQuery(data).find('svg');
      // Add replaced image's ID to the new SVG
      if (typeof imgID !== 'undefined') {
        $svg = $svg.attr('id', imgID);
      }
      // Add replaced image's classes to the new SVG
      if (typeof imgClass !== 'undefined') {
        $svg = $svg.attr('class', imgClass + ' replaced-svg');
      }
      // Remove any invalid XML tags as per http://validator.w3.org
      $svg = $svg.removeAttr('xmlns:a');
      // Replace image with new SVG
      $img.replaceWith($svg);
    }, 'xml');
  });



  var beforeClick = false,
    beforeClass = false;
  // Mobile Menu
  $('.mobile-menu__btn').on('click', function () {
    $('.mobile-menu').toggleClass('mobile-menu_open');
    $('html, body').toggleClass('overflowHidden');
    $(this).add('.container.mobile .logo').toggleClass('z-index');
    beforeClick = !beforeClick;
    // (beforeClick) ? $('header').toggleClass('gray') console.log('open'): $('header').removeClass('gray')
    if (beforeClick) {
      console.log(beforeClick, 'if');
      beforeClass = ($('header').hasClass('gray'));
      console.log(beforeClass, 'beforeClass');
      if (!beforeClass) {
        $('header').addClass('gray')
      }
    } else {
      if (!beforeClass) {
        $('header').removeClass('gray')
      }
    }
  });

  // Filter Menu
  var filterMnu = new filterMenu('.filter__btn_open', '.filter__menu', '.icon-close-icon');

  function filterMenu(sBtn, sMenuContainer, sClose) {
    var button = $(sBtn),
      menu = $(sMenuContainer),
      close = menu.find(sClose),
      item = menu.find('.filter__btn'),
      container = $('.mobile__filter_container .filter__btn');
    var show = function () {
        $(this).removeClass('active');
        menu.addClass('filter__menu_open');
        $('html, body').addClass('overflowHidden');
        item.each(function () {
          ($(this).text() === container.text()) ? $(this).addClass('active') : $(this).removeClass('active');
          $(this).on('click', function (e) {
            e.preventDefault();
            container.html($(this).text());
            menu.removeClass('filter__menu_open');
            $('html, body').removeClass('overflowHidden');
          })
        });
      },
      hide = function () {
        menu.removeClass('filter__menu_open');
        $('html, body').removeClass('overflowHidden');
      };
    button.bind('click', show);
    close.bind('click', hide);
  }

  // Toggle Filter Class
  $('.filter__btn').each(function () {
    $(this).on('click', function (e) {
      $('.filter__btn').removeClass('active');
      e.preventDefault();
      $(this).addClass('active');
    })
  });

  //Smooth Scroll to anchor
  $(".smooth").on("click", function (event) {
    event.preventDefault();
    var id = $(this).attr('href'),
      top = $(id).offset().top;
    top -= 100;
    $('body,html').animate({scrollTop: top}, 1000);
  });


  $('.shri-mataji .section_btn').on('click', function () {
    $(this).toggleClass('active')
  });

  // OwlCarousel
  $(".carousel-video").owlCarousel({
    center: true,
    loop: true,
    nav: true,
    dots: false,
    video: true,
    margin: 60,
    autoWidth: true,
    smartSpeed: 700,
    navText: ['<i class="icon-arrow-left"></i>', '<i class="icon-arrow-right"></i>'],
    responsiveClass: true,
    responsive: {
      0: {
        items: 1
      },
      768: {
        items: 1
      },
      992: {
        items: 1
      },
      1400: {
        items: 3
      }
    }

  });

  $('.owl-pagination .owl-page, .owl-buttons div').on('click', function () {
    $('.owl-item div').css('height', $('.owl-item div').css('height'));
  });


  // SVG Vivus Animation
  $('.footer__illustration').each(function (i) {
    var el = $(this).attr('id', 'footer_custom_' + i)
    new Vivus(el.attr('id'), {duration: 200, file: $(this).data('svg')})
  })

  $('.img__circle').each(function (i) {
    var el = $(this).attr('id', 'img__circle_' + i)
    new Vivus(el.attr('id'), {duration: 200, file: $(this).data('svg')})
  })
})

//  ON ORIENTATION CHANGE
$(window).on('orientationchange', function () {
  $(".container").each(function (index, domEle) {
    var textWidth = $('.text-width', this).outerWidth();
    var containerHeight = $(this).height();
    $(".s_title", this).css("min-width", containerHeight);
    $(this).css("min-height", textWidth);
  });

  $('.article_technique .article__image').each(function () {
    $(this).height($(this).width());
  })
});

//  ON RESIZE ON RELOAD
$(window).on('resize load', function () {

  if ($('main.page-main').length || $('main.page-meditate').length) {
    if (window.matchMedia("(min-width : 992px) and (max-width : 1400px)").matches) {
      $('.header, .s__hero .container').addClass('zoom')
    } else {
      $('.header, .s__hero .container').removeClass('zoom')
    }
  }


  $('.article_technique .article__image').each(function () {
    $(this).height($(this).width());
    $(this).width($(this).height());
  });

  $(".container").each(function (index, domEle) {
    var textWidth = $('.text-width', this).outerWidth();
    var containerHeight = $(this).height();
    $(".s_title", this).css("min-width", containerHeight);
    $(this).css("min-height", textWidth);
  });

  // Equal height
  function equalItems() {
    $(".meditate-why .item-equal").equalHeights();
  }

  equalItems();

  if (matchMedia('only screen and (min-device-width : 320px) and (max-width : 1023px)').matches) {
    var items = $('.intro-grid .item'); // delete animation delay
    items.each(function () {
      $(this).removeAttr("data-wow-delay");
      $(this).data();
    });

    initChakrasSlider();
  }


  if (matchMedia('only screen and (min-width : 768px) and (max-width : 1024px)').matches) {
    // Change Device Orientation
    $(window).on('orientationchange', function (event) {
      (orientation === -90 || orientation === 90) ? destroyChakrasSlider() : initChakrasSlider()
    });
  }

  // Scale Pages
  function scale() {
    (matchMedia('only screen and (min-width : 992px) and (max-width : 1400px)').matches && $('.header.gray').length) ? $('body').addClass('zoom') : $('body').removeClass('zoom')
  }

  scale();

  // AutoMargin
  function AutoMargin(sSelector) {
    var element = $(sSelector),
      elementHeight = element.height(),
      textHeight = element.find('.article__text').height(),
      margin = elementHeight + textHeight;
    element.css('margin-bottom', margin)
  }

  if (matchMedia('only screen and (max-width: 480px) and (orientation:portrait)').matches) {
    $('.s__howto .article').removeClass('article_inversion').removeClass('draw-line');
    AutoMargin('.s__howto');
    AutoMargin('.s__mataji');
    AutoMargin('.s__sahaja');
  }
  else {
    $('.s__howto .article').addClass('article_inversion').addClass('draw-line');
    $('.s__mataji').css('margin-bottom', '');
    $('.s__howto').css('margin-bottom', '');
    $('.s__sahaja').css('margin-bottom', '');
  }

  // Change Header Bg On Mobile
  if ($(window).width() <= 480) {
    $('.s_video').addClass('has__gradient_blue');
    $('.s-sahaja .container-text').removeClass('container-text-inverse');
    var items = $('.intro-grid .item'); // delete animation delay
    items.each(function () {
      $(this).removeAttr("data-wow-delay");
      $(this).data();
    });
  } else {
    $('.s__meditate .container').removeClass('has__triangle has__triangle_right');
    $('.s__mataji').css('margin-bottom', '');
  }

  //  Preloader
  $('body').addClass('fixed');
  $('.preloader').delay(1000).fadeOut('slow', function () {
    $('body').removeClass('fixed');
  });

  //var circle = $('.img__circle').attr('id', 'circle_new'),
  //  circleId = circle.attr('id');

  //  WOW JS
  setTimeout(function () {
    var e = new WOW({
      boxClass: "wow",
      animateClass: "animated",
      offset: 0,
      mobile: !0,
      live: !0,
      callback: function (e) {
        if ($(e).hasClass('draw-line')) {
          setTimeout(function () {
            $(e).addClass('active');
          }, 1500);

        } else if ($(e).hasClass('btn__container')) {
          setTimeout(function () {
            $(e).removeClass('wow fadeIn');
            $(e).addClass('animated infinite pulse').css('animation-name', 'pulse');
          }, 5000);
        } else if ($(e).hasClass('chakras_wrapper')) {
          setTimeout(function () {
            svgAnimation();
          }, 1500);
        }
      },
      scrollContainer: null
    });
    e.init();
  }, 500);
})
