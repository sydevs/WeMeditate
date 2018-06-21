
$(document).on('turbolinks:load', function() {
  $('.ui.city.search').each(function() {
    $(this).search({
      searchDelay: 300,
      minCharacters: 3,
      selectFirstResult: true,
      searchOnFocus: false,
      fullTextSearch: true,
      apiSettings: {
        url: $(this).data('url'),
      },
      onSelect: function(result, response) {
        $('#city_name').val(result.name)
        $('#city_latitude').val(result.latitude)
        $('#city_longitude').val(result.longitude)
        $('#city_coordinates span').text(result.latitude + ', ' + result.longitude)
        $(this).search('hide results')
        return false
      },
    })
  })
})
