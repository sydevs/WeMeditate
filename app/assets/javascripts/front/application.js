
const Application = {

  preloaded: false,

  init() {
    document.querySelector('.footer__scrollback').addEventListener('click', event => {
      zenscroll.toY(0)
      event.preventDefault()
    })

    Application.element.header.init()
  },

  load() {
    Application.loadImages()
    Application.loadAnimations()
    if (!Application.videoPlayer) {
      Application.videoPlayer = Video.loadPlayer('video-player')
    }

    const preloader = document.querySelector('.preloader')
    if (Application.preloaded && preloader) {
      preloader.remove()
    }

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
      let element = Application.element[id]
      if (typeof element.unload === 'function') {
        console.log('unloading', id)
        element.unload()
      }
    }

    for (let selector in Application.elements) {
      for (let key in Application.elements[selector]) {
        let element = Application.elements[selector][key]
        if (typeof element.unload === 'function') {
          console.log('unloading', selector)
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

  loadAnimations() {
    console.log('Load animations')
    this.animations = document.querySelectorAll('.js-animate')
    window.addEventListener('scroll', () => this.activateAnimations())
    window.addEventListener('resize', () => this.activateAnimations())
  },

  activateAnimations() {
    const pageYOffset = window.pageYOffset
    const viewportHeight = window.innerHeight;     

    for (let i = 0; i < this.animations.length; i++) {
      let element = this.animations[i]
      if (element == null) continue

      let offsetTop = zenscroll.getTopOf(element) + (element.offsetHeight * 0.5)
      if (offsetTop > pageYOffset && offsetTop < pageYOffset + viewportHeight) {
        element.classList.add('animate')
        this.animations[i] = null
      }
    }
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

      svg = $(svg).filter('svg')[0] // Convert our string to an element

      if (background) {
        const firstGroupElement = svg.querySelector('g, path, ellipse, rect')
        svg.style.background = firstGroupElement.getAttribute('stroke') || firstGroupElement.getAttribute('fill')
      }

      target.replaceWith(svg)
    })
  },

  isMobileDevice() {
    return navigator.userAgent.match(/Android/i)
        || navigator.userAgent.match(/webOS/i)
        || navigator.userAgent.match(/iPhone/i)
        || navigator.userAgent.match(/iPad/i)
        || navigator.userAgent.match(/iPod/i)
        || navigator.userAgent.match(/BlackBerry/i)
        || navigator.userAgent.match(/Windows Phone/i)
  },

  isTouchDevice() {
    return ('ontouchstart' in window) || (navigator.MaxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0)
  },
}

document.addEventListener('ready', ()  => Application.init())
document.addEventListener('turbolinks:load', ()  => Application.load())
document.addEventListener('turbolinks:before-cache', ()  => Application.unload())
window.addEventListener('load', function() {
  $('.preloader').delay(1000).fadeOut('slow')
  Application.preloaded = true
})