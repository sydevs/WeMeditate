import $ from 'jquery'
import autosize from 'autosize'
import Sortable from 'sortablejs'
import RepeatableFields from 'repeatable-fields'
import initDraftSystem from './features/draft'
import initFormFeatures from './features/form'

// $, Sortable, Editor, RepeatableFields, autosize

/** Admin
 * This file orchestrates all the code for the administrative part of the website (ie. admin.wemeditate.co)
 */

export function load() {
  console.log('loading Admin.js') // eslint-disable-line no-console

  // Initialize javascript-reliant elements for the entire body
  init($(document.body))
  initDraftSystem()
  initFormFeatures()

  // Activate the loader icon on form submit
  $('form').on('submit', function() {
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
  //RepeatableFields.initialize(scope)

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
  //scope.find('input[type=file]').on('change', event => this.onChangeFileInput(event.target))
  //scope.find('.js-vimeo-field input').on('change', event => this.onRefreshVimeoInput(event.target.parentNode.parentNode))
  //scope.find('.js-vimeo-field + .preview-item .reload').on('click', event => this.onRefreshVimeoInput(event.target.parentNode.previousSibling))
}