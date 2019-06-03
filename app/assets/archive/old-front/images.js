/** Images
 * This file is used to handle lazyloading and render inline SVG files.
 * Inline SVGs are necessary when we can't render the SVG inline on the server side because the SVG comes from remote file storage.
 */

const Images = {
  // Called when turbolinks loads the page
  load() {
    console.log('loading Images.js')
    new LazyLoad({
      elements_selector: '.lazyload',
    })

    // Find and render all instances of "inline-svg"
    $('.inline-svg').each(function() {
      let $element = $(this)
      Images.render_svg($element, $element.data('url'), $element.data('namespace'), $element.data('background') == true)
    })
  },

  // Render a specific .inline-svg instance.
  render_svg($target, url, namespace, background) {
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

$(document).on('turbolinks:load', () => { Images.load() })
