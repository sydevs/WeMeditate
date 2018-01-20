
$(document).on('turbolinks:load', function() {
  $('body').on('click', '.edit.button', function() {
      $(this).closest('.item').toggleClass('editing')
  })

  $('body').on('click', '.new-object-button', function() {
    var list = $(this).siblings('.object-list')
    var template = $(this).siblings('.object-template').html()

    var result = list.append(template)
    result.accordion()
  })
})
