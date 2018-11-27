$(document).on('turbolinks:load', function() {
  var set = 1;

  //  Chapter Nav
  if ($('main.page-article').length) {
    if (window.matchMedia("(max-width: 1440px)").matches) {
      $('.page-article .s_together').attr("data-wow-offset", "-600")
    } else {
      $('.page-article .s_together').removeAttr("data-wow-offset")
    }

    function setGradientWidth(set) {
      $('.chapter-nav').append('<div class="chapter-nav-gradient"></div>');
      $('.chapter-nav-gradient').width(($('.chapter-nav li').outerWidth() * set))
    }

    setGradientWidth(set);


    var lastScrollTop = 0;
    $(document).on("scroll", onScroll);
    $('.chapter-nav a').on('click', function (e) {
      e.preventDefault();
      $(document).off("scroll");
      $('.chapter-nav a').each(function () {
        $(this).removeClass('active');
      });
      $(this).addClass('active');
      var target = this.hash,
        $target = $(target),
        targetOffset = $target.offset().top;
      targetOffset -= 200;
      $('html, body').animate({scrollTop: targetOffset}, 1000, function () {
        $(document).on("scroll", onScroll);
      });
    });

    function onScroll() {
      var st = $(this).scrollTop();
      var scrollPos = $(document).scrollTop();
      $('.chapter-nav a').each(function () {
        var currLink = $(this),
          refElement = $(currLink.attr("href")),
          currItem = currLink.parent(),
          prevItem = currItem.prev();
        if ((refElement.position().top - 200) <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
          $('.chapter-nav a').removeClass("active");
          currLink.addClass("active");
          if (window.matchMedia("(max-width: 459px)").matches) {
            //  Check scroll direction
            if (st > lastScrollTop) {
              prevItem.hide();
              currItem.show();
            } else {
              currItem.next().add(currItem.prev()).hide();
              currItem.show();
            }
            lastScrollTop = st;
          }
        }
        else {
          currLink.removeClass("active");
        }
      });
    }

    var $w = $(window);
    $('.chapter-nav li').each(function () {
      var link = $(this).find('a'),
        itemProgressIndicator = link.next(),
        itemID = link.attr('href'),
        sectionHeight = $(itemID).outerHeight(true),
        sectionPosition = $(itemID).position().top;
      $w.on('scroll', function () {
        if ($w.scrollTop() <= sectionPosition + sectionHeight) {
          itemProgressIndicator.css({
            width: (Math.max(0, Math.min(1, (($w.scrollTop() + 200) - sectionPosition) / sectionHeight))) * 100 + '%'
          });
        } else {
          itemProgressIndicator.css('width', "100%");
        }
      });
    });

    //  Sticky Chapter Nav
    $('.chapter-nav-wrapper').stick_in_parent({
      offset_top: 85
    });
  }

  function fullScreenArticle(sSelector) {
    var element = $(sSelector),
      text = element.find('.container-text').html();
    element.after('<div class="helper">' + text + '</div>');
  }

  if (matchMedia('only screen and (max-width: 767px)').matches) {
    fullScreenArticle('.s-sahaja');
  }

})
