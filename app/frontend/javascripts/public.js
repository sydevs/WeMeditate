import $ from 'jquery'
import { initLazyImages, initInlineSVGs } from './public/images.js'
import { init, load, unload } from './public/application.js'

let preloaded = false
let preloader

document.addEventListener('DOMContentLoaded', () => {
  init()
  initLazyImages()
  initInlineSVGs()

  preloader = document.querySelector('.preloader')
  if (preloader) {
    if (preloaded) {
      preloader.remove()
    } else {
      document.body.classList.add('noscroll')
    }
  }
})

window.addEventListener('load', function() {
  $('.preloader').delay(1000).fadeOut('slow')
  document.body.classList.remove('noscroll')
  preloaded = true
  init()
})

document.addEventListener('turbolinks:load', () => load())
document.addEventListener('turbolinks:before-cache', () => unload())
