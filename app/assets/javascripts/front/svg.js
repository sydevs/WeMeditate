/** SVG
 * This file is used to render inline SVG files.
 * This is necessary when we can't render the SVG inline on the server side because the SVG comes from remote file storage.
 */

const SVG = {
  // Called when turbolinks loads the page
  load() {
    console.log('loading SVG.js')
    // Find and render all instances of "inline-svg"
    $('.inline-svg').each(function() {
      let $element = $(this)
      SVG.render($element, $element.data('url'), $element.data('namespace'), $element.data('background') == true)
    })
  },

  // Render a specific .inline-svg instance.
  render($target, url, namespace, background) {
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

$(document).on('turbolinks:load', () => { SVG.load() })
