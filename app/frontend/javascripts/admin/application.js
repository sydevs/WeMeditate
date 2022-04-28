import $ from 'jquery'
import autosize from 'autosize'
import Sortable from 'sortablejs'
import initDraftSystem from './features/draft'
import initFormFeatures from './features/form'
import initContentEditor from './features/editor'
import initFileUploader from './features/uploader'
import initReviewPage from './features/review'
import TimeZonesMap from './elements/time-zones-map'
import RepeatableFields from './elements/repeatable-fields'

/** Admin
 * This file orchestrates all the code for the administrative part of the website (ie. admin.wemeditate.com)
 */

export function load() {
  console.log('loading Admin.js') // eslint-disable-line no-console

  // Initialize javascript-reliant elements for the entire body
  init($(document.body))
  initDraftSystem()
  initFormFeatures()
  initContentEditor()
  initFileUploader()
  initReviewPage()

  const timeZoneMap = document.getElementById('timezone-map')
  new TimeZonesMap(timeZoneMap) // eslint-disable-line no-new

  // Activate the loader icon on form submit
  $('form:not(#editor-form)').on('submit', function() {
    $(this).addClass('loading')
    $('#loader').addClass('active')
  })

  // Activate the loader icon when pagination buttons are clicked
  $('#pagination').on('click', 'a', function() {
    $('#loader').addClass('active')
  })

  // Initialize the Sortable library for sortable lists
  $('.sort-list').each(function() {
    Sortable.create(this, {
      handle: '.handle',
      draggable: '.sortable',
    })

    var list = $(this)
    list.closest('form').on('submit', function() {
      // Before any form is submitted, we need to update the order value for each item in this list.
      list.children('.sortable').each(function(index) {
        $(this).children('.sorting-order').val(index + 1)
      })
    })
  })
}

export function init(scope) {
  // Initialize basic javascript elements.
  scope.find('.ui.checkbox').checkbox()
  scope.find('.tabs.menu > .item').tab()
  scope.find('.ui.accordion').accordion()
  scope.find('.ui.date.picker').calendar({ type: 'date' })
  autosize(scope.find('textarea'))

  scope.find('.repeatable.fields').each(function() {
    new RepeatableFields(this) // eslint-disable-line no-new
  })

  // Initialize dropdown elements.
  scope.find('.ui.dropdown:not(.simple)').each(function() {
    var $element = $(this)
    var options = {
      fullTextSearch: true,
    }

    if ($element.hasClass('clearable')) {
      options.clearable = true
    }

    $element.dropdown(options)
  })

  // Add callbacks for a few input types
  scope.find('input[type=file]').on('change', event => onChangeFileInput(event.target))
  scope.find('.js-vimeo-field input').on('change', event => onRefreshVimeoInput(event.target.parentNode.parentNode))
  scope.find('.js-vimeo-field + .preview-item .reload').on('click', event => onRefreshVimeoInput(event.target.parentNode.previousSibling))
}

// DEPRECATED VIMEO FUNCTIONS
// TODO: Remove this code
// When a file input has it's file changes, we need to update the preview.
function onChangeFileInput(input) {
  const $img = $(input).next('.image').children('img')

  if ($img.length > 0 && input.files && input.files[0]) {
    const reader = new FileReader()
    reader.onload = function(event) {
      $img.attr('src', event.target.result)
    }

    reader.readAsDataURL(input.files[0])
  }
}

// When vimeo metadata is refreshed, we need to make the appropriate server requests
function onRefreshVimeoInput(field) {
  const vimeo_id = field.querySelector('input').value
  const input = field.querySelector('.input')
  const meta = field.nextSibling

  if (!vimeo_id || isNaN(vimeo_id)) {
    // If the vimeo id isn't valid, then hide this whole section
    meta.querySelector('.content').style.display = 'none'
  } else {
    meta.querySelector('.content').style.display = null
    input.classList.add('loading')

    retrieveVimeoVideo(vimeo_id, response => {
      // Render a preview of the returned meta data, and store it to an input to be saved.
      meta.querySelector('.raw').innerText = JSON.stringify(response, null, 2)
      meta.querySelector('img').src = response.thumbnail
      meta.querySelector('.hint').innerText = response.title
      meta.querySelector('a').href = `https://vimeo.com/${response.vimeo_id}`
      meta.querySelector('input').value = JSON.stringify(response)

      input.classList.remove('loading')
    })
  }
}

// Requests vimeo metadata from our server's vimeo data endpoint
function retrieveVimeoVideo(vimeo_id, callback) {
  $.ajax({
    url: `/${window.locale}/vimeo_data?vimeo_id=${vimeo_id}`,
    type: 'GET',
    dataType: 'json',
    success: function(result) {
      callback(result)
    },
  })
}