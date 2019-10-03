
let Admin = {
  load: function() {
    console.log('loading Admin.js')
    Admin.initialize($(document.body))

    $('form').on('submit', function() {
      $(this).addClass('loading')
      $('#loader').addClass('active')
    })

    $('#pagination').on('click', 'a', function() {
      $('#loader').addClass('active')
    })

    $('.sort-list').each(function() {
      Sortable.create(this, {
        handle: ".handle",
        draggable: ".sortable",
      })

      var list = $(this)
      list.closest('form').on('submit', function() {
        list.children('.sortable').each(function(index) {
          $(this).children('.sorting-order').val(index + 1)
        })
      })
    })
  },

  initialize: function(scope) {
    scope.find('.ui.checkbox').checkbox()
    scope.find('.tabs.menu > .item').tab()
    scope.find('.ui.accordion').accordion()
    scope.find('.ui.date.picker').calendar({ type: 'date' })
    autosize(scope.find('textarea'))

    $('.ui.dropdown').each(function() {
      var element = $(this)
      var options = {}
      if (element.hasClass('clearable')) {
        options['clearable'] = true
      }

      element.dropdown(options)

      // This is a workaround to fix default values for a multiple select
      // TODO: Is this workaround still necessary?
      if (element.hasClass('multiple')) {
        var selected = []
        selected.push(element.find('option:selected').val())
        element.dropdown('set selected', selected)
        element.children('input[type="hidden"]').val(null)
      }
    })

    RepeatableFields.initialize(scope)

    $('input[type=file]').on('change', event => this.onChangeFileInput(event.target))
    $('.js-vimeo-field input').on('change', event => this.onRefreshVimeoInput(event.target.parentNode))
    $('.js-vimeo-field + .preview-item .reload').on('click', event => this.onRefreshVimeoInput(event.target.parentNode.previousSibling))
  },

  onChangeFileInput(input) {
    const $img = $(input).next('.image').children('img')

    if ($img.length > 0 && input.files && input.files[0]) {
      const reader = new FileReader()
      reader.onload = function(event) {
        $img.attr('src', event.target.result);
      }
      
      reader.readAsDataURL(input.files[0]);
    }
  },

  onRefreshVimeoInput(field) {
    const vimeo_id = field.querySelector('input').value
    const input = field.querySelector('.input')
    const meta = field.nextSibling

    if (!vimeo_id || isNaN(vimeo_id)) {
      meta.querySelector('.content').style.display = 'none'
    } else {
      meta.querySelector('.content').style.display = null
      input.classList.add('loading')
      Editor.adjustPendingUploads(+1)
      Editor.retrieveVimeoVideo(vimeo_id, response => {
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
