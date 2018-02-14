$(document).on('turbolinks:load', function() {
  console.log('loading header.js')

  //  Chapter Nav Hide
  $(window).on('scroll', function () {
    var chapterNavWr = $('.page-article-no-img .chapter-nav-wrapper');
    if ($(this).scrollTop() > 300) {
      chapterNavWr.fadeIn()
    } else {
      chapterNavWr.fadeOut()
    }
  })

  //  Come meditate mobile dropdown
  $('.div-toggle').each(function () {
    var $this = $(this), numberOfOptions = $(this).children('option').length;

    $this.addClass('select-hidden');
    $this.wrap('<div class="select hide-desktop"></div>');
    $this.after('<div class="select-styled hide-desktop"></div>');

    var $styledSelect = $this.next('div.select-styled');
    $styledSelect.text($this.children('option').eq(0).text());

    var $list = $('<ul />', {
      'class': 'select-options'
    }).insertAfter($styledSelect);

    for (var i = 0; i < numberOfOptions; i++) {
      $('<li />', {
        text: $this.children('option').eq(i).text(),
        rel: $this.children('option').eq(i).val()
      }).appendTo($list);
    }

    var $listItems = $list.children('li');

    $styledSelect.click(function (e) {
      e.stopPropagation()

      $('div.select-styled.active').not(this).each(function () {
        $(this).removeClass('active').next('ul.select-options').hide()
      })

      $(this).toggleClass('active').next('ul.select-options').toggle()
    });

    $listItems.click(function (e) {
      e.stopPropagation()
      $('.city-info > div').addClass('hide')
      $styledSelect.text($(this).text()).removeClass('active')
      $this.val($(this).attr('rel'))
      $('.' + $(this).attr('rel')).removeClass('hide')
      $list.hide()
    })

    $(document).click(function () {
      $styledSelect.removeClass('active')
      $list.hide()
    })

  })

  //  Change Header Color
  if (!($('header').hasClass('gray'))) {
    var $header = $('.header');
    var $win = $(window);
    var winH = $win.height();
    $win.on("scroll", function () {
      ($(this).scrollTop() > winH) ? $header.addClass('gray') : $header.removeClass('gray');
    }).on("resize", function () {
      winH = $(this).height();
    });
  }

  //  Burger Menu
  $('.burger__button').on('click', function (e) {
    e.preventDefault();
    $(this).toggleClass('open');
    $('.header__nav').slideToggle();
    $('header').toggleClass('wide-header');
    $('.chapter-nav-wrapper').toggleClass('wide-chapter');
    return false;
  });

  //  Sticky Header
  $(window).scroll(function () {
    var winTop = $(window).scrollTop();
    if (winTop >= 30) {
      $("body").addClass("sticky-header");
      if (!$('.burger__button').hasClass('open')) {
        $('.header__nav').fadeOut();
        $('.header__breadcrumbs').addClass('hidden');
      }

      if (window.matchMedia("(max-width: 459px)").matches) {
        $('header').addClass('gray')
      }
    } else {
      $("body").removeClass("sticky-header");
      $('.header__nav').fadeIn();
      $('.header__breadcrumbs').removeClass('hidden')
    }//if-else
  });//win func.
  
});

