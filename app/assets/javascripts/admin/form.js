/* global $ */
/* exported Form */

/** Form
 * Custom code for the admin forms
 */

const Form = {
  load() {
    console.log('loading Form.js') // eslint-disable-line no-console
    $('#article_article_type').on('change', Form._onSetArticleType)
    $('#article_article_type').trigger('change')

    $('.ui.toggle.button').on('click', Form._toggleButton)
  },

  _onSetArticleType() {
    const value = this.value

    $('[data-type-segment]').each(function() {
      const $segment = $(this)

      if (this.dataset.typeSegment == value) {
        $segment.find('input, select, textarea').attr('disabled', false)
        $segment.show()
      } else {
        $segment.find('input, select, textarea').attr('disabled', true)
        $segment.hide()
      }
    })
  },

  _toggleButton() {
    const active = this.classList.toggle('active')
    this.querySelector('input').checked = active
  },
}

$(document).on('turbolinks:load', () => { Form.load() })
