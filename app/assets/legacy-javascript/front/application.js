/* global $, LazyLoad, zenscroll,
  Accordion, Carousel, Dropdown, Form, Grid, Loadmore, Video, ImageGallery, ReadingTime, CountdownTimer
  Header, SubtleSystem, MusicPlayer, CustomMeditation, Prescreen, GeoSearch, LanguageSwitcher, Categories */
/* exported Application */

/** Front Application
 * This file orchestrates and loads all the other files in this folder.
 */

const Application = {

  preloaded: false, // Tracks whether the preloader has already been triggered.

  init() {
    const scrollback = document.querySelector('.footer__scrollback')
    if (scrollback) {
      scrollback.addEventListener('click', event => {
        zenscroll.toY(0)
        event.preventDefault()
      })
    }

    if (Application.element.header) Application.element.header.init()
    if (Application.element.categories) Application.element.categories.init()
  },

  load() {
    Application.loadImages()
    Application.loadAnimations()

    const preloader = document.querySelector('.preloader')
    if (preloader) {
      if (Application.preloaded) {
        preloader.remove()
      } else {
        document.body.classList.add('noscroll')
      }
    }

    window.afterglow.initVideoElements()

    Application.elements = {}
    Application.loadAll('accordion', Accordion)
    Application.loadAll('carousel', Carousel)
    Application.loadAll('dropdown', Dropdown)
    Application.loadAll('form', Form)
    Application.loadAll('grid', Grid)
    Application.loadAll('loadmore', Loadmore)
    Application.loadAll('video', Video)
    Application.loadAll('gallery', ImageGallery)
    Application.loadAll('reading-time', ReadingTime)
    Application.loadAll('countdown', CountdownTimer)

    Application.element = {}
    Application.loadFirst('header', Header)
    Application.loadFirst('subtle-system', SubtleSystem)
    Application.loadFirst('music-player', MusicPlayer)
    Application.loadFirst('custom-meditation', CustomMeditation)
    Application.loadFirst('prescreen', Prescreen)
    Application.loadFirst('geosearch', GeoSearch)
    Application.loadFirst('language-switcher', LanguageSwitcher)
    Application.loadFirst('categories', Categories)
  },

  unload() {
    for (let id in Application.element) {
      let element = Application.element[id]
      if (typeof element.unload === 'function') {
        console.log('unloading', id) // eslint-disable-line no-console
        element.unload()
      }
    }

    for (let selector in Application.elements) {
      for (let key in Application.elements[selector]) {
        let element = Application.elements[selector][key]
        if (typeof element.unload === 'function') {
          console.log('unloading', selector) // eslint-disable-line no-console
          element.unload()
        }
      }
    }

    Application.elements = {}
    Application.element = {}
  },

  loadAll(selector, Klass) {
    console.log('loading', selector) // eslint-disable-line no-console
    const result = []
    document.querySelectorAll(`.js-${selector}`).forEach(element => {
      console.log('Init', selector, 'on', element) // eslint-disable-line no-console
      result.push(new Klass(element, result.length))
    })

    Application.elements[selector] = result
  },

  loadFirst(id, Klass) {
    console.log('Init', id, 'on', document.getElementById(id)) // eslint-disable-line no-console
    var element = document.getElementById(id)
    if (element) Application.element[id] = new Klass(element)
  },

  loadAnimations() {
    console.log('Load animations') // eslint-disable-line no-console
    this.animations = document.querySelectorAll('.js-animate')
    window.addEventListener('scroll', () => this.activateAnimations())
    window.addEventListener('resize', () => this.activateAnimations())
  },

  activateAnimations() {
    const pageYOffset = window.pageYOffset
    const viewportHeight = window.innerHeight     

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

    // Find and render all instances of "js-inline-svg"
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
  },

  get orientation() {
    return window.innerWidth > window.innerHeight ? 'horizontal' : 'vertical'
  },

  get isMobileDevice() {
    return navigator.userAgent.match(/Android/i)
        || navigator.userAgent.match(/webOS/i)
        || navigator.userAgent.match(/iPhone/i)
        || navigator.userAgent.match(/iPad/i)
        || navigator.userAgent.match(/iPod/i)
        || navigator.userAgent.match(/BlackBerry/i)
        || navigator.userAgent.match(/Windows Phone/i)
  },

  get isTouchDevice() {
    return ('ontouchstart' in window) || (navigator.MaxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0)
  },
}

document.addEventListener('ready', () => Application.init())
document.addEventListener('turbolinks:load', () => Application.load())
document.addEventListener('turbolinks:before-cache', () => Application.unload())

window.addEventListener('load', function() {
  $('.preloader').delay(1000).fadeOut('slow')
  document.body.classList.remove('noscroll')
  Application.preloaded = true
  Application.init()
})