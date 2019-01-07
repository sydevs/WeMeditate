/** MAPS
 * The city and country pages both make use of two different kinds of maps.
 * We implement these using the Leaflet library.
 *
 * The country page uses a simple SVG map with Leaflet marker layer over top to position cities.
 * The city page uses a more traditional embeded OpenStreetMaps map.
 */

const Map = {
  // Viewport padding for the Leaflet maps.
  padding: [40, 0],

  // Called when turbolinks loads the page
  load() {
    console.log('loading Map.js')
    $('.map[data-type=country]').each(Map._load_country_map)
    $('.map[data-type=city]').each(Map._load_city_map)
  },

  // Returns markup for a map marker
  get_marker_html(name, url) {
    return '<a class="map-list-item" href="'+url+'">'+name+'</a>'
  },

  // Setups and maintains bounds for the map, by resizing it when the window is resized.
  setup_bounds(map, bounds) {
    let resizeTimer = null

    // Set up the initial bounds.
    map.fitBounds(bounds, { padding: Map.padding })

    // Set up a callback on window resize
    $(window).resize(function() {
      // We use a timer so that the map isn't resizing constantly when you drag the window on desktop.
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

  // Called on load to load any country maps on the page.
  _load_country_map() {
    let $map = $(this)
    let bounds = $map.data('bounds')

    // Initialize the map
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

    // Retrieve the country SVG
    $.getJSON($map.data('src'), function(data) {
      // Add the country SVG to the Leaflet map
      let layer = new L.GeoJSON(data, {
        interactive: false,
      })
      layer.addTo(map)

      // Define the bounds of the map
      bounds = (bounds == null || typeof bounds === 'undefined') ? layer.getBounds() : bounds
      Map.setup_bounds(map, bounds)
      bounds = map.getBounds()

      // Get the container for listing cities which don't fit on the map.
      let extra_markers_list = $map.siblings('.map-list.desktop-only')
      extra_markers_list.children('.map-list-item').remove()

      // For each marker, either place it on the map (if it is within bounds), or add it to the extras container.
      $map.data('markers').forEach(function(marker) {
        let latlng = [marker.latitude, marker.longitude]

        if (bounds.contains(latlng)) {
          // Create a marker on the map.
          new L.marker(latlng, {
            icon: new L.DivIcon({
              className: 'map-marker',
              html: Map.get_marker_html(marker.name, marker.url)
            }),
          }).addTo(map)
        } else {
          // Add the marker to the extra cities list.
          extra_markers_list.append(Map.get_marker_html(marker.name, marker.url))
          extra_markers_list.show()
        }
      })
    })
  },

  // Called on load to load any city maps on the page.
  _load_city_map() {
    let markers = []

    // Create the generic icon used for markers on this map.
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

    // Initialize the leaflet map.
    let map = L.map(this, {
      zoomControl: false,
      attributionControl: false,
      scrollWheelZoom: false,
    })

    // Add the zoom control to the top right of the map
    /*L.control.zoom({
      position: 'topright',
    }).addTo(map)*/

    // Add the tile layer
    L.tileLayer('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>'
    }).addTo(map)

    //new L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?', {}).addTo(map)

    /*L.tileLayer('https://{s}.tile.openstreetmap.se/hydda/full/{z}/{x}/{y}.png', {
      maxZoom: 18,
      attribution: 'Tiles courtesy of <a href="http://openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map)*/

    // Add each venue for this map as a marker
    $(this).data('venues').forEach(function(venue) {
      markers.push(L.marker([venue.latitude, venue.longitude], { icon: new Icon }))
    })

    // Add the marker group to the map.
    let markerGroup = L.featureGroup(markers).addTo(map)

    // Fit the map bounds to contain all markers.
    let bounds = markerGroup.getBounds().pad(0.5)
    bounds = bounds.extend(new L.LatLng(bounds.getNorth(), bounds.getWest() - 0.05))
    map.fitBounds(bounds)
  },
}

$(document).on('turbolinks:load', Map.load)
