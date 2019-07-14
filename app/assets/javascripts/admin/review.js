
const Review = {
  load() {
    console.log('loading Review.js')
    $('.review.table').on('click', '.positive.button', Review._onApproveAll)
    $('.review.table').on('click', '.negative.button', Review._onRejectAll)
  },

  _onApproveAll(event) {
    $(event.delegateTarget).find('.ui.checkbox').checkbox('check')
  },

  _onRejectAll(event) {
    $(event.delegateTarget).find('.ui.checkbox').checkbox('uncheck')
  },
}

$(document).on('turbolinks:load', () => { Review.load() })
