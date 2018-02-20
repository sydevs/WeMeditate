$(document).on('turbolinks:load', function() {
  if (window.matchMedia("(max-width: 459px)").matches) {
    $('.s-life .text-box').add('.s-ancient .text-box').removeClass('inverse');
    $('.map-popup').hide();
    $('a.marker').click(function (e) {
      e.preventDefault();
      e.stopPropagation();
      $(this).next('.map-popup').show().removeClass('open');
      $(this).parent().siblings().children('.map-popup').hide().removeClass('open');
    });
    $(document).click(function () {
      $('.map-popup').hide().removeClass('open');
    });

    $(".chapter-nav li").slice(0, 1).show().css('display', 'flex');
  }

  //  MAP MARKER
  var $pop = $('.map-popup');
  $pop.click(function (e) {
    e.stopPropagation();
  });

  $('a.marker').click(function (e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).next('.map-popup').toggleClass('open');
    $(this).parent().siblings().children('.map-popup').removeClass('open');
  });

  $(document).click(function () {
    $pop.removeClass('open');
  });
})
