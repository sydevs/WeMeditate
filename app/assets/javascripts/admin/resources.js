
$(document).on('turbolinks:load', function() {
  $('body').on('click', '.edit.button', function() {
    $(this).closest('.item').toggleClass('editing')
  })

  $('body').on('click', '.new-section-button', function() {
    var list = $(this).siblings('.section-list')
    var template = $(this).siblings('.section-template').html()

    var result = list.append(template)
    result.accordion()
    result.find('.ui.dropdown').dropdown()
  })
  
  $('body').on('click', '.remove-section-button', function() {
    $(this).closest('.section').remove()
  })
})
