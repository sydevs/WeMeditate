$(document).on('turbolinks:load', function() {
  console.log('loading shri-mataji.js')

  if ($('main.page-shri-mataji').length) {
    if (window.matchMedia("(max-width: 1440px)").matches) {
      $('.s__articles').add('.s_together').attr("data-wow-offset", "-600")
      $('.s__articles .article__item').attr("data-wow-offset", "-800")
    } else {
      $('.s__articles').add('.s_together').removeAttr("data-wow-offset")
    }
  }

})
