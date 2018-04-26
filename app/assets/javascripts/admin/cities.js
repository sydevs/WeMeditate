
$(document).on('turbolinks:load', function() {
  $('.ui.city.search').each(function() {
    $(this).search({
      debug: true,
      searchDelay: 300,
      selectFirstResult: true,
      fullTextSearch: true,
      apiSettings: {
        url: $(this).data('url'),
      },
      onSelect: function(result, response) {
        $('#city_name').val(result.city_name)
        $('#city_latitude').val(result.latitude)
        $('#city_longitude').val(result.longitude)
        $('#city_coordinates span').text(result.latitude + ', ' + result.longitude)
        $(this).search('hide results')
        return false
      },
      minCharacters: 3,
      //showNoResults: true,
    })
  })
})
