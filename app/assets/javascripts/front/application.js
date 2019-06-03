
const Application = {
  load() {
    Application.loadImages()
    Application.videoPlayer = Video.loadPlayer('video-player')

    Application.carousels = Application.loadAll('carousel', Carousel)
    Application.dropdowns = Application.loadAll('dropdown', Dropdown)
    Application.forms = Application.loadAll('form', Form)
    Application.grids = Application.loadAll('grid', Grid)
    Application.loadmores = Application.loadAll('loadmore', Loadmore)
    Application.videos = Application.loadAll('video', Video)
    Application.imageGalleries = Application.loadAll('gallery', ImageGallery)

    Application.header = Application.loadFirst('header', Header)
    Application.subtleSystem = Application.loadFirst('subtle-system', SubtleSystem)
    Application.musicPlayer = Application.loadFirst('music-player', MusicPlayer)
    Application.customMeditation = Application.loadFirst('custom-meditation', CustomMeditation)
  },

  loadAll(selector, Klass) {
    console.log('loading', selector)
    const result = []
    document.querySelectorAll(`.js-${selector}`).forEach(element => {
      console.log('Init', selector, 'on', element)
      result.push(new Klass(element, result.length))
    })

    return result
  },

  loadFirst(id, Klass) {
    console.log('Init', id, 'on', document.getElementById(id))
    var element = document.getElementById(id)
    if (element) return new Klass(element)
  },

  loadImages() {
    new LazyLoad({ elements_selector: '.js-image' })

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

jQuery(document).on('turbolinks:load', ()  => Application.load())
