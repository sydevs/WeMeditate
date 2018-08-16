
var SVG = {
  // These variables will be set on load
  video_player: null,

  load: function() {
    console.log('loading SVG.js')
    $('.inline-svg').each(function() {
      let $element = $(this)
      SVG.render($element, $element.data('url'), $element.data('namespace'), $element.data('background') == true)
    })
  },

  render: function($target, url, namespace, background) {
    $.ajax({
      url: url,
      dataType: 'text',
      type: 'GET',
      error: function (jqXHR, status, errorThrown) {
        console.log('SVG Error', status, errorThrown)
      }
    }).done(function(svg) {
      if (svg.includes('<style>') && typeof namespace !== 'undefined') {
        svg = svg.replace('<style>', '<style>.' + namespace + ' ')
      }

      let $svg = $(svg).addClass(namespace).replaceAll($target)
      let $path = $svg.find('path')
      let color = $path.css('fill') === 'none' ? $path.css('stroke') : $path.css('fill')
      $svg.data('color', color)

      if (background) {
        $svg.css('background-color', color)
      }
    })
  },
}

$(document).on('turbolinks:load', function() { SVG.load() })
