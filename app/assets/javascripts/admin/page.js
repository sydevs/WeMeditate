
let Page = {
  form: null, // To be set on load

  load: function() {
    console.log('Load Page.js')
    Page.form = $('#page-form')
    Page.form.on('change', '.section .field-content-type select', Page._on_section_type_change)
    Page.form.on('change', '.section .field-format select', Page._on_section_format_change)
    Page.form.on('change', '.child .delete-child', Page._on_delete_child_change)
    Page.form.on('click', '.remove-child-button', Page._on_remove_child)
    Page.form.on('click', '.sections.list [data-form-prepend]', Page._on_prepend_section)
    Page.form.on('submit', Page._on_submit)
  },

  _on_section_type_change: function() {
    console.log('On section content type change')
    var section = $(this).closest('.section')

    section.removeClass(function (index, className) {
      return (className.match(/(^|\s)(format|type)-\S+/g) || []).join(' ')
    });

    content_type = $(this).val()
    section.addClass('type-' + content_type)

    format = $('.section .fields.for.'+content_type+' .field-format option:selected').val()
    section.addClass('format-' + format)
  },

  _on_section_format_change: function() {
    var section = $(this).closest('.section')

    section.removeClass(function (index, className) {
      return (className.match (/(^|\s)format-\S+/g) || []).join(' ')
    });

    section.addClass('format-' + $(this).children("option").filter(":selected").val())
  },

  _on_prepend_section: function() {
    var section = $($(this).attr('data-form-prepend'))
    var id = (new Date()).getTime()

    section.find('input, select, textarea').each(function() {
      $(this).attr('name', function() {
        return $(this).attr('name').replace('new_record', id)
      })
    })

    $('.ui.accordion').accordion('close', 0)
    section.insertBefore(this)
    Admin.initialize(section)
    section.accordion('open', 0)

    return false
  },

  _on_delete_child_change: function() {
    var child = $(this).closest('.child')
    child.toggleClass('deleting', this.checked)

    if (this.checked) {
      child.accordion('close', 0)
    }
  },

  _on_remove_child: function() {
    $(this).closest('.child').remove()
  },

  _on_submit: function() {
    $('.ui.accordion').accordion('close', 0)

    $(this).find('.section').each(function() {
      var content_type = $(this).find('.static_page_sections_content_type select').val()
      if (typeof content_type !== 'undefined') {
        $(this).find('.grouped.fields.for:not(.'+content_type+') :input').attr('disabled', true)
      }
    })
  },
}

$(document).on('turbolinks:load', function() {
  if ($('#page-form').length > 0) {
    Page.load()
  }
})
