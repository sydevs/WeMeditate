
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
      case 'rich_text':
        let quill = Quill.find($field.find('.rich-text-editor')[0])
        quill.setText('')
        quill.clipboard.dangerouslyPasteHTML(value)
        break
      case 'collection':
      case 'association':
        console.log('set select', $field.find('select'), value)
        $field.find('.ui.selection').dropdown('set selected', value)
        break
      case 'media':
        Media.set_input($field.find('.ui.media.input'))
        Media.set_value(value)
        break
      case 'decorations':
        console.log('reset', value)
        if (typeof value === 'undefined') value = { enabled: [], options: {} }

        // Loop through each decoration
        $decorations = $field.children('.decoration').each((_, decoration) => {
          console.log('set decoration', decoration)
          $decoration = $(decoration)
          $checkbox = $decoration.find('input[type=checkbox]')
          console.log($checkbox)
          type = $checkbox.val() // Get the type of the decoration
          enabled = value.enabled.indexOf(type) != -1

          // Set the checkbox value
          $checkbox.prop('checked', enabled)

          if (enabled) {
            // Loop through each dropdown
            console.log(type, 'vs', value.options)
            if (type in value.options) {
              $decoration.find('.ui.dropdown').each((_, dropdown) => {
                $dropdown = $(dropdown)
                $dropdown.find('.item').each((_, item) => {
                  console.log('dropdown test', item.dataset.value, 'vs', value.options[type])
                  if (value.options[type].indexOf(item.dataset.value) != -1) {
                    $dropdown.dropdown('set selected', item.dataset.value)
                  }
                })
              })
            } else {
              $decoration.find('.ui.dropdown').dropdown('clear')
            }

            if (type == 'sidetext') $decoration.find('.section_extra_sidetext > input').val(value.sidetext)
          } else {
            $decoration.find('.ui.dropdown').dropdown('clear')
            if (type == 'sidetext') $decoration.find('.section_extra_sidetext > input').val('')
          }
        })
        break
      default:
        console.error('TODO: Draft reset is not yet implemented for', $field.data('draft'))
    }
  },
}

$(document).on('turbolinks:load', () => { Draft.load() })
