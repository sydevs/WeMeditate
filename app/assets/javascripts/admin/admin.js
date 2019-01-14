
let Admin = {
  load: function() {
    console.log('Load Admin.js')
    Admin.initialize($(document))

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
    scope.find('.tabs > *').tab()
    scope.find('.ui.accordion').accordion()
    scope.find('.ui.date.picker').calendar({ type: 'date' })
    autosize(scope.find('textarea'))

    $('.ui.dropdown').each(function() {
      var element = $(this)
      element.dropdown()

      // This is a workaround to fix default values for a multiple select
      // TODO: Is this workaround still necessary?
      if (element.hasClass('multiple')) {
        var selected = []
        selected.push(element.find('option:selected').val())
        element.dropdown('set selected', selected)
        element.children('input[type="hidden"]').val(null)
      }
    })

    $('.ui.venue.search').each(function() {
      $(this).search({
        searchDelay: 300,
        minCharacters: 3,
        selectFirstResult: true,
        searchOnFocus: false,
        fullTextSearch: true,
        apiSettings: {
          url: $(this).data('url'),
        },
        onSelect: function(result, response) {
          //$('#city_name').val(result.city_name)
          //$('#city_latitude').val(result.latitude)
          //$('#city_longitude').val(result.longitude)
          //$('#city_coordinates span')
          $(this).siblings('.latitude').val(result.latitude)
          $(this).siblings('.longitude').val(result.longitude)
          $(this).find('.label span').text(result.latitude + ', ' + result.longitude)
          //$(this).search('hide results')
          //return false
        },
      })
    })

    scope.find('.repeatable.fields').each(function() {
      $(this).repeatable_fields({
        row_count_placeholder: '{{row-count-placeholder}}',
        after_add: function(container, new_row) {
          Admin.initialize(new_row)

          var row_count = $(container).attr('data-rf-row-count')
          row_count++

          $('*', new_row).each(function() {
            $.each(this.attributes, function() {
              this.value = this.value.replace('{{row-count-placeholder}}', row_count - 1)
            })
          })

			    $(container).attr('data-rf-row-count', row_count)
        }
      })
    })

    scope.find('.rich-text-editor').each(function() {
      let input = $(this).prev('input')
      let quill = new Quill(this, {
        formats: [ 'link', 'bold', 'italic', 'underline' ],
        modules: {
          toolbar: [
            ['link'],
            ['bold', 'italic', 'underline'],
          ],
        },
        theme: 'snow',
      })

      quill.on('text-change', function() {
        input.val(quill.root.innerHTML)
      })
    })
  },

}

$(document).on('turbolinks:load', Admin.load)
