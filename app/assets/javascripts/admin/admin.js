
$(document).on('turbolinks:load', function() {
  $('.ui.dropdown').dropdown()
  $('.ui.checkbox').checkbox()
  $('.ui.accordion').accordion()

  $('.sort-list').each(function() {
    Sortable.create(this, {
      handle: ".handle",
      draggable: ".sortable",
    })

    var list = $(this)
    list.closest('form').on('submit', function() {
      list.children('.sortable').each(function(index) {
        $(this).children('.sorting-order').val(index + 1)
      })
    })
  })
})
