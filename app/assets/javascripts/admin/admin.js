/* global $, Sortable, Editor, RepeatableFields, autosize */
/* exported Admin */

/** Admin
 * This file orchestrates all the code for the administrative part of the website (ie. admin.wemeditate.co)
 */

const Admin = {
  load: function() {
    console.log('loading Admin.js') // eslint-disable-line no-console

    // Initialize javascript-reliant elements for the entire body
    Admin.initialize($(document.body))

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
  },

  initialize: function(scope) {
    // Initialize basic javascript elements.
    scope.find('.ui.checkbox').checkbox()
    scope.find('.tabs.menu > .item').tab()
    scope.find('.ui.accordion').accordion()
    scope.find('.ui.date.picker').calendar({ type: 'date' })
    autosize(scope.find('textarea'))
    RepeatableFields.initialize(scope)

    // Initialize dropdown elements.
    scope.find('.ui.dropdown:not(.simple)').each(function() {
      var $element = $(this)
      var options = {}
      if ($element.hasClass('clearable')) {
        options.clearable = true
      }

      $element.dropdown(options)

      // This is a workaround to fix default values for a multiple select
      // TODO: Is this workaround still necessary?
      // As of Oct 27, 2019 this has been commented out. If this doesn't cause any issues in the next week or so, we can delete it.
      /*if ($element.hasClass('multiple')) {
        var selected = []
        selected.push($element.find('option:selected').val())
        $element.dropdown('set selected', selected)
        $element.children('input[type="hidden"]').val(null)
      }*/
    })

    // Add callbacks for a few input types
    scope.find('input[type=file]').on('change', event => this.onChangeFileInput(event.target))
    scope.find('.js-vimeo-field input').on('change', event => this.onRefreshVimeoInput(event.target.parentNode.parentNode))
    scope.find('.js-vimeo-field + .preview-item .reload').on('click', event => this.onRefreshVimeoInput(event.target.parentNode.previousSibling))
  },

  // When a file input has it's file changes, we need to update the preview.
  onChangeFileInput(input) {
    const $img = $(input).next('.image').children('img')

    if ($img.length > 0 && input.files && input.files[0]) {
      const reader = new FileReader()
      reader.onload = function(event) {
        $img.attr('src', event.target.result)
      }
      
      reader.readAsDataURL(input.files[0])
    }
  },

  // When vimeo metadata is refreshed, we need to make the appropriate server requests
  onRefreshVimeoInput(field) {
    const vimeo_id = field.querySelector('input').value
    const input = field.querySelector('.input')
    const meta = field.nextSibling

    if (!vimeo_id || isNaN(vimeo_id)) {
      // If the vimeo id isn't valid, then hide this whole section
      meta.querySelector('.content').style.display = 'none'
    } else {
      meta.querySelector('.content').style.display = null
      input.classList.add('loading')
      Editor.adjustPendingUploads(+1)

      Editor.retrieveVimeoVideo(vimeo_id, response => {
        // Render a preview of the returned meta data, and store it to an input to be saved.
        meta.querySelector('.raw').innerText = JSON.stringify(response, null, 2)
        meta.querySelector('img').src = response.thumbnail
        meta.querySelector('.hint').innerText = response.title
        meta.querySelector('a').href = `https://vimeo.com/${response.vimeo_id}`
        meta.querySelector('input').value = JSON.stringify(response)
        
        input.classList.remove('loading')
        Editor.adjustPendingUploads(-1)
      })
    }
  },

}

$(document).on('turbolinks:load', Admin.load)
