import $ from 'jquery'
import Lazyload from 'lazyload'

let lazyloader

function renderSVG(target, url, namespace, background) {
  $.ajax({
    url: url,
    dataType: 'text',
    type: 'GET',
    error: function (_jqXHR, status, errorThrown) {
      console.error('SVG Error', status, errorThrown) // eslint-disable-line no-console
    }
  }).done(function(svg) {
    if (svg.includes('<style>') && typeof namespace !== 'undefined') {
      svg = svg.replace('<style>', '<style>.' + namespace + ' ')
    }

    svg = $(svg).filter('svg')[0] // Convert our string to an element

    if (background) {
      const firstGroupElement = svg.querySelector('g, path, ellipse, rect')
      svg.style.background = firstGroupElement.getAttribute('stroke') || firstGroupElement.getAttribute('fill')
    }

    target.replaceWith(svg)
  })
}

export function initLazyImages() {
  let images = document.querySelectorAll('.js-image')
  console.log(images)
  lazyloader = new Lazyload(images)
}

export function initInlineSVGs() {
  document.querySelectorAll('.js-inline-svg').forEach(element => {
    renderSVG(element, element.dataset.url, element.dataset.namespace, element.dataset.background == true)
  })
}