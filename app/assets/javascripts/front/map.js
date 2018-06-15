
const Map = {
  padding: [40, 0],

  // These variables will be set on load
  //maps: null,
  //resizeTimer: null,

  load: function() {
    console.log('loading Map.js')
    //Map.maps = []
    //Map.resizeTimer = null

    $('.country.map').each(Map._load_country_map)
    $('.city.map').each(Map._load_city_map)
    //$(window).resize(Map._on_resize)
  },

  get_city_html: function(name, url) {
    return '<a class="city" href="'+url+'">'+name+'</a>'
  },

  setup_bounds: function(map, bounds) {
    let resizeTimer = null
    map.fitBounds(bounds, { padding: Map.padding })

    $(window).resize(function() {
      clearTimeout(resizeTimer)
      resizeTimer = setTimeout(function() {
        console.log('Resize', map)
        map.fitBounds(bounds, {
          padding: Map.padding,
          animate: false,
        })
        map.invalidateSize()
      }, 250)
    })
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

    //Map.maps.push(map)
    //new L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?', {}).addTo(map);

    $.getJSON(element.data('src'), function(data) {
      let layer = new L.GeoJSON(data)

      layer.addTo(map)

      bounds = (bounds == null || typeof bounds === 'undefined') ? layer.getBounds() : bounds
      Map.setup_bounds(map, bounds)
      bounds = map.getBounds()

      let extra_cities_container = element.parent().find('.extra')
      extra_cities_container.children('.cities').empty()

      element.data('cities').forEach(function(city) {
        let latlng = [city.latitude, city.longitude]

        if (bounds.contains(latlng)) {
          new L.marker(latlng, {
            icon: new L.DivIcon({
              className: 'marker',
              html: Map.get_city_html(city.name, city.url)
            }),
          }).addTo(map)
        } else {
          extra_cities_container.children('.cities').append('<p>' + Map.get_city_html(city.name, city.url) + '</p>')
          extra_cities_container.show()
        }
      })
    })
  },

  _load_city_map: function() {
    let markers = []
    let Icon = L.Icon.extend({
      options: {
        iconUrl: '/maps/marker/icon.png',
        iconRetinaUrl: '/maps/marker/icon-2x.png',
        shadowUrl: '/maps/marker/shadow.png',
        iconSize:      [25, 41],
        iconAnchor:    [12, 41],
        popupAnchor:   [1, -34],
        tooltipAnchor: [16, -28],
        shadowSize:    [41, 41],
      },
    })

    let map = L.map(this, {
      zoomControl: false,
      attributionControl: false,
      scrollWheelZoom: false,
    })

    L.control.zoom({
      position: 'topright',
    }).addTo(map)

    //new L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?', {}).addTo(map)

    /*L.tileLayer('https://{s}.tile.openstreetmap.se/hydda/full/{z}/{x}/{y}.png', {
      maxZoom: 18,
      attribution: 'Tiles courtesy of <a href="http://openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map)*/

    L.tileLayer('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>'
    }).addTo(map)

    $(this).data('venues').forEach(function(venue) {
      markers.push(L.marker([venue.latitude, venue.longitude], { icon: new Icon }))
    })

    let markerGroup = L.featureGroup(markers).addTo(map)
    map.fitBounds(markerGroup.getBounds().pad(0.5))
  },
}

$(document).on('turbolinks:load', Map.load)
