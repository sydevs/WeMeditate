
var Articles = {
  grid: null, // To be defined on load

  load: function() {
    Articles.grid = $('#grid')
    Articles.grid.isotope({
      itemSelector: 'article',
    })

    $('.filter-categories a').on('click', Articles._on_category_select)
  },

  _on_category_select: function(e) {
    var filter = $(this).data('filter')
    console.log('filter by', filter, 'from', this)

    Articles.grid.isotope({
      filter: filter ? '.' + filter : null
    })

    e.preventDefault()
  }

}

$(document).on('turbolinks:load', function() { Articles.load() })
console.log('loading Articles.js')
