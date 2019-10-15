/** Draft
 * This sets up a few simple handlers that let us toggle between draft values and live values for an input field.
 */

const Draft = {
  load() {
    console.log('loading Draft.js')
    $('.draft.field .reset.button').on('click', Draft._onSet)
    $('.draft.field .redo.button').on('click', Draft._onSet)
  },

  _onSet() {
    let $trigger = $(this)
    let $field = $trigger.closest('.field')
    let value = $trigger.data('value')
    $field.toggleClass('draft')

    // Handle the code necessary to set each different type of draftable field.
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
        console.error('Draft reset is not yet implemented for', $field.data('draft'))
    }
  },
}

$(document).on('turbolinks:load', () => { Draft.load() })
