
$(document).on('turbolinks:load', function() {
  $('body').on('click', '.edit.button', function() {
    $(this).closest('.item').toggleClass('editing')
  })

  $('body').on('click', '.save.button', function() {
    $(this).closest('form').addClass('loading')
  })
})
