/** Front Application
 * This file orchestrates and loads all the other files in this folder.
 */

import zenscroll from 'zenscroll'
import Accordion from './elements/accordion'
import Carousel from './elements/carousel'
import CountdownTimer from './elements/countdown-timer'
import Dropdown from './elements/dropdown'
import Form from './elements/form'
import Grid from './elements/grid'

import Header, { setHeader } from './features/header'
import CategoriesMenu from './features/categories-menu'
import CustomMeditation from './features/custom-meditation'
import GeoSearch from './features/geosearch'


let instances = {}
window.instances = instances

function loadAll(selector, Klass) {
  console.log('loading', selector) // eslint-disable-line no-console
  const result = []
  document.querySelectorAll(`.js-${selector}`).forEach(element => {
    console.log('Init', selector, 'on', element) // eslint-disable-line no-console
    result.push(new Klass(element, result.length))
  })

  instances[selector] = result
}

function loadFirst(id, Klass) {
  console.log('Init', id, 'on', document.getElementById(id)) // eslint-disable-line no-console
  var element = document.getElementById(id)

  if (element) {
    instances[id] = [new Klass(element)]
  }
}

export function init() {
  const scrollback = document.querySelector('.footer__scrollback')
  if (scrollback) {
    scrollback.addEventListener('click', event => {
      zenscroll.toY(0)
      event.preventDefault()
    })
  }

  if (instances.header && instances.header.count > 0) instances.header[0].init()
  if (instances.categories && instances.categories.count > 0) instances.categories[0].init()
}

export function load() {
  loadAll('accordion', Accordion)
  loadAll('carousel', Carousel)
  loadAll('countdown', CountdownTimer)
  loadAll('dropdown', Dropdown)
  loadAll('form', Form)
  loadAll('grid', Grid)
  /*
  loadAll('loadmore', Loadmore)
  loadAll('video', Video)
  loadAll('gallery', ImageGallery)
  loadAll('reading-time', ReadingTime)
  */

  loadFirst('header', Header)
  setHeader(instances.header[0])
  loadFirst('categories-menu', CategoriesMenu)
  loadFirst('custom-meditation', CustomMeditation)
  loadFirst('geosearch', GeoSearch)
  /*
  loadFirst('subtle-system', SubtleSystem)
  loadFirst('music-player', MusicPlayer)
  loadFirst('prescreen', Prescreen)
  loadFirst('language-switcher', LanguageSwitcher)
  */

}

export function unload() {
  for (let selector in instances) {
    for (let key in instances[selector]) {
      let instance = instances[selector][key]
      if (typeof instance.unload === 'function') {
        console.log('unloading', selector) // eslint-disable-line no-console
        instance.unload()
      }
    }
  }

  instances = {}
}
