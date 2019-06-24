
const Application = {

  init() {
    Application.videoPlayer = Video.loadPlayer('video-player')

    document.querySelector('.footer__scrollback').addEventListener('click', event => {
      zenscroll.toY(0)
      event.preventDefault()
    })
  },

  load() {
    Application.loadImages()

    Application.elements = {}
    Application.loadAll('accordion', Accordion)
    Application.loadAll('carousel', Carousel)
    Application.loadAll('dropdown', Dropdown)
    Application.loadAll('form', Form)
    Application.loadAll('grid', Grid)
    Application.loadAll('loadmore', Loadmore)
    Application.loadAll('video', Video)
    Application.loadAll('gallery', ImageGallery)

    Application.element = {}
    Application.loadFirst('header', Header)
    Application.loadFirst('subtle-system', SubtleSystem)
    Application.loadFirst('music-player', MusicPlayer)
    Application.loadFirst('custom-meditation', CustomMeditation)
    Application.loadFirst('prescreen', Prescreen)
  },

  unload() {
    for (let id in Application.element) {
      console.log('unloading', id)
      let element = Application.element[id]
      if (typeof element.unload === 'function') {
        element.unload()
      }
    }

    for (let selector in Application.elements) {
      console.log('unloading', selector)
      for (let key in Application.elements[selector]) {
        let element = Application.elements[selector][key]
        if (typeof element.unload === 'function') {
          element.unload()
        }
      }
    }

    Application.elements = {}
    Application.element = {}
  },

  loadAll(selector, Klass) {
    console.log('loading', selector)
    const result = []
    document.querySelectorAll(`.js-${selector}`).forEach(element => {
      console.log('Init', selector, 'on', element)
      result.push(new Klass(element, result.length))
    })

    Application.elements[selector] = result
  },

  loadFirst(id, Klass) {
    console.log('Init', id, 'on', document.getElementById(id))
    var element = document.getElementById(id)
    if (element) Application.element[id] = new Klass(element)
  },

  loadImages() {
    Application.lazyloader = new LazyLoad({ elements_selector: '.js-image' })

    // Find and render all instances of "[data-svg]"
    document.querySelectorAll('.js-inline-svg').forEach(element => {
      Application.renderSVG(element, element.dataset.url, element.dataset.namespace, element.dataset.background == true)
    })
  },

  renderSVG(target, url, namespace, background) {
    $.ajax({
      url: url,
      dataType: 'text',
      type: 'GET',
      error: function (_jqXHR, status, errorThrown) {
        console.log('SVG Error', status, errorThrown)
      }
    }).done(function(svg) {
      if (svg.includes('<style>') && typeof namespace !== 'undefined') {
        svg = svg.replace('<style>', '<style>.' + namespace + ' ')
      }

      svg = $(svg)[0] // Convert our string to an element

      if (background) {
        svg.style.background = svg.firstChild.getAttribute('stroke') || svg.firstChild.getAttribute('fill')
      }

      target.replaceWith(svg)
    })
  },
}

document.addEventListener('ready', ()  => Application.init())
document.addEventListener('turbolinks:load', ()  => Application.load())
document.addEventListener('turbolinks:before-cache', ()  => Application.unload())
