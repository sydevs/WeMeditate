
let Section = {
  form: null, // To be set on load

  load: function() {
    console.log('Load Section.js')
    Section.form = $('#section-form')
    Section.form.on('change', '.section .field-content-type select', Section._on_section_type_change)
    Section.form.on('change', '.section .field-format select', Section._on_section_format_change)
    Section.form.on('submit', Section._on_submit)
  },

  _on_section_type_change: function() {
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

  _on_submit: function() {
    var content_type = Section.form.find('.field-content-type select').val()

    if (typeof content_type !== 'undefined') {
      Section.form.find('.grouped.fields.for:not(.'+content_type+') :input').attr('disabled', true)
      Section.form.find('.grouped.fields.for.'+content_type+' .field').each(function() {
        $group = $(this)

        if ($group.css('display') == 'none') {
          $group.find(':input').attr('disabled', true)
          console.log('disabling', $group.find(':input'))
        }
      })
    }
  },
}

$(document).on('turbolinks:load', function() {
  if ($('#section-form').length > 0) {
    Section.load()
  }
})
