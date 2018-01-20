
$(document).on('turbolinks:load', function() {
  $('.ui.dropdown').dropdown()
  $('.ui.accordion').accordion()

  $('.sortable.items').each(function() {
    Sortable.create(this, {
      handle: ".handle",
      draggable: ".item",
    })

    console.log('sorting', this)
  })
})
