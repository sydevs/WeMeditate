import $ from 'jquery'
import { initLazyImages, initInlineSVGs, updateLazyloader } from './public/images'
import { init, load, unload } from './public/application'

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

window.addEventListener('load', () => init())

document.addEventListener('turbolinks:load', () => {
  load()
  updateLazyloader()
  initInlineSVGs()

  preloader = document.querySelector('.preloader')
  if (preloaded) {
    $('.preloader').remove()
  } else {
    $('.preloader').delay(1000).fadeOut('slow')
    document.body.classList.remove('noscroll')
    preloaded = true
  }
})

document.addEventListener('turbolinks:before-cache', () => unload())
