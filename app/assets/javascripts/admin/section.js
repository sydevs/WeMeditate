
let Section = {
  // To be set on load
  form: null,
  content_type: null,
  format: null,
  fields: null,
  items_input: null,

  load() {
    console.log('loading Section.js')
    Section.form = $('#section-form')
    Section.fields = Section.form.find('.field.for, .fields.for')
    Section.content_type = Section.form.find('#section-content-type select')
    Section.format = Section.form.find('#section-format select')
    Section.items_input = Section.form.find('#items-input')

    Section.content_type.on('change', Section._on_type_change)
    Section.format.on('change', Section._on_format_change)
    Section.form.on('submit', Section._on_submit)

    Section._on_type_change.apply(Section.content_type, [false])
    Section._on_format_change.apply(Section.format)
  },

  set_items_fields(mode) {
    Section.items_input.find('input[type=url]').toggle(mode == 'grid')
    Section.items_input.find('.media.input').toggle(mode == 'columns')
  },

  _on_type_change(change_format = true) {
    content_type = $(this).val()
    $items = Section.format.siblings('.menu').children('.item')
    $items.hide()

    Section.format.children('option.for-'+content_type).each((i, element) => {
      format = $(element).val()
      $items.filter('[data-value='+format+']').show()
      if (i == 0 && change_format) Section.format.parent().dropdown('set selected', format)
    })
  },

  _on_format_change() {
    var content_type = Section.content_type.val()
    var format = Section.format.val()

    Section.fields.hide()
    Section.fields.filter('.'+content_type+'-'+format).show()

    if (Section.items_input.css('display') != 'none') {
      Section.items_input.find('input[type=url]').toggle(format == 'grid')
      Section.items_input.find('.media.input').toggle(format == 'columns')
    }
  },

  _on_submit() {
    Section.fields.filter(':not(:visible) :input').attr('disabled', true)
  },
}

$(document).on('turbolinks:load', () => {
  if ($('#section-form').length > 0) {
    Section.load()
  }
})
