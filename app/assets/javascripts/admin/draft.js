
const Draft = {
  load() {
    console.log('loading Draft.js')
    $('.draft.field .reset.button').on('click', Draft._on_set)
    $('.draft.field .redo.button').on('click', Draft._on_set)
    $('.repeatable.draft.field .reset.button').on('click', Draft._on_reset_repeatable)
  },

  _on_set() {
    let $trigger = $(this)
    let $field = $trigger.closest('.field')
    let value = $trigger.data('value')
    $field.toggleClass('draft')

    switch ($field.data('draft')) {
      case 'string':
        $field.find('input').val(value)
        break
      case 'text':
        $field.find('textarea').val(value)
        break
      case 'date':
        $field.find('.ui.date.picker').calendar('set date', value)
        break
      case 'toggle':
        $field.find('.ui.checkbox').checkbox(value ? 'check' : 'uncheck')
        break
      case 'collection':
      case 'association':
        $field.find('.ui.selection').dropdown('set selected', value)
        break
      case 'media':
        $field.find('img').attr('src', value.src)
        $field.find('input[type=hidden]').attr('value', value.id)
        break
      case 'repeatable':
        RepeatableFields.reset($field, value)
        break
      case 'content':
        Editor.instance.render(value)
        break
      default:
        console.error('TODO: Draft reset is not yet implemented for', $field.data('draft'))
    }
  },
}

$(document).on('turbolinks:load', () => { Draft.load() })
