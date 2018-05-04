
const Map = {
  load: function() {
    console.log('loading Map.js')
    $('.country.map').each(Map._load_country_map)
  },

  _load_country_map: function() {
    let element = $(this)
    let bounds = element.data('bounds')
    let map = new L.Map(this, {
      zoomSnap: 0,
      boxZoom: false,
      doubleClickZoom: false,
      dragging: false,
      zoomControl: false,
      attributionControl: false,
      keyboard: false,
      scrollWheelZoom: false,
      tap: false,
    })

    //new L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?', {}).addTo(map);

    $.getJSON(element.data('src'), function(data) {
      let layer = new L.GeoJSON(data, {
        /*coordsToLatLng: function(coords) {
          longitude = coords[0]; latitude = coords[1]
          var latlng = L.latLng(latitude, longitude)

          if (longitude < 0) {
            return latlng.wrap(360, 0)
          } else {
            return latlng.wrap()
          }
        },*/
      })

      layer.addTo(map)

      bounds = (bounds == null || typeof bounds === 'undefined') ? layer.getBounds() : bounds
      map.fitBounds(bounds, { padding: [40, 0] })
      bounds = map.getBounds()

      let extra_cities_container = element.parent().find('.extra')
      extra_cities_container.children('.cities').empty()

      element.data('cities').forEach(function(city) {
        let latlng = [city.latitude, city.longitude]

        if (bounds.contains(latlng)) {
          new L.marker(latlng, {
            icon: new L.DivIcon({
              className: 'marker',
              html: '<a class="city" href="'+city.url+'">'+city.name+'</a>'
            }),
          }).addTo(map)
        } else {
          console.log("EXTRA", extra_cities_container, city)
          extra_cities_container.children('.cities').append('<p><a class="city" href="'+city.url+'">'+city.name+'</a></p>')
          extra_cities_container.show()
        }
      })
    })
  },

  _load_city_map: function() {

  },
}

$(document).on('turbolinks:load', function() { Map.load() })
