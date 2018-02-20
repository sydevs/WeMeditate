
$(document).on('turbolinks:load', function() {
  $('.ui.checkbox').checkbox()
  $('.ui.accordion').accordion()
  $('.tabs > *').tab()

  autosize($('textarea'))

  $('.ui.dropdown').each(function() {
    var element = $(this)
    element.dropdown()
    
    // This is a workaround to fix default values for a multiple select
    if (element.hasClass('multiple')) {
      var selected = []
      selected.push(element.find('option:selected').val())
      element.dropdown('set selected', selected)
      element.children('input[type="hidden"]').val(null)
    }
  })

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

  $('.ui.search').each(function() {
    $(this).search({
      debug: true,
      apiSettings: {
        url: $(this).data('url'),
      },
      onSelect: function(result, response) {
        $('#city_name').val(result.city_name)
        $('#city_latitude').val(result.latitude)
        $('#city_longitude').val(result.longitude)
        $('#city_coordinates span').text(result.latitude + ', ' + result.longitude)
      },
      minCharacters: 3,
      //showNoResults: true,
    })
  })
})
