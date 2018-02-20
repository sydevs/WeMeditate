
var Articles = {
  grid: null, // To be defined on load

  load: function() {
    Articles.grid = $('#grid')
    Articles.grid.isotope({
      itemSelector: '.article',
    })

    $('.topline__filter a').on('click', Articles._on_category_select)
  },

  _on_category_select: function() {
    console.log('filter by', $(this).data('filter'), 'from', this)
    var filter = $(this).data('filter')

    Articles.grid.isotope({
      filter: filter ? '.' + filter : null
    })
  }

}

$(document).on('turbolinks:load', function() { Articles.load() })
console.log('loading Articles.js')
