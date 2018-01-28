
$(document).on('turbolinks:load', function() {
  $('body').on('click', '.edit.button', function() {
    $(this).closest('.item').toggleClass('editing')
  })
})
