/* global $ */
/* exported Form */

/** Draft
 * This sets up a few simple handlers that let us toggle between draft values and live values for an input field.
 */

const Form = {
  load() {
    console.log('loading Form.js') // eslint-disable-line no-console
    $('#article_article_type').on('change', Form._onSetArticleType)
    $('#article_article_type').trigger('change')
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
}

$(document).on('turbolinks:load', () => { Form.load() })
