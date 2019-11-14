/* global $ */
/* exported Review */

/** REVIEW
 * Handles behaviours for the admin review page.
 */

const Review = {

  load() {
    console.log('Load Review.js') // eslint-disable-line no-console
    this.selectedId = null

    // Store a few elemennts from the page.
    // The review page will have two tabs, and two embedded iframes to show previews of the final content.
    // One for the page's archive preview (ie. 'details'), and one for the page itself (ie. 'content')
    this.$detailsReview = $('#details-review')
    this.detailsIframe = document.getElementById('details-iframe')
    this.$contentReview = $('#content-review')
    this.contentIframe = document.getElementById('content-iframe')

    // Setup zenscroll for the sidebar menu.
    //this.menuScroller = zenscroll.createScroller(document.getElementById('review-menu').firstChild, 1000, 50)

    // Set up evetns
    $('#review-form').on('submit', _event => this.storeReviewData())
    $('.review-button').on('mouseenter', event => this.highlightBlock(event.currentTarget.dataset))
    $('.review-button:not(.disabled)').on('click', event => this.toggleApproval(event.currentTarget.dataset))

    if (this.detailsIframe) {
      // Add a callback to resize the details frame whenever it reloads
      this.detailsIframe.addEventListener('load', function() {
        this.style.height = (this.contentWindow.document.body.scrollHeight + 10) + 'px'
      })
    }
  },

  // Stores all the selected review actions in the review form's input field.
  // This should be run just before the view page is submitted, to prepare the data to be sent to the server.
  storeReviewData() {
    const data = []
    $('.review-button').each(function(index, element) {
      const effect = element.classList.contains('approved') ? element.dataset.effect : 'nochange'
      data.push({ id: element.dataset.id, effect: effect })
    })

    $('#review-input').val(JSON.stringify({
      details: this.getApprovedDetailChanges(),
      content: data,
    }))
  },

  // Gets the changeset for all approved detail changes.
  getApprovedDetailChanges() {
    let result = []

    $('.review-button[data-context="details"]').each(function(index, element) {
      if (element.classList.contains('approved')) {
        result.push(element.dataset.id)
      }
    })

    return result
  },

  // The review page is made up of two contexts 'details' and 'content'
  // This function allows you to switch the display between those two contexts.
  showContext(context) {
    const $from = (context == 'details') ? this.$contentReview : this.$detailsReview
    const $to = (context == 'details') ? this.$detailsReview : this.$contentReview
    if ($from.css('display') == 'none') {
      $to.fadeIn('fast')
    } else {
      $from.fadeOut('fast', () => $to.fadeIn('fast'))
    }
  },

  // Highlight any specified review block.
  // Expected arguments:
  //   context - the context that this block belongs to which should be shown
  //   refresh - whether the details iframe should be highlighted as well
  highlightBlock(args) {
    this.showContext(args.context)

    if (this.selectedId) {
      $(`.review-block[data-id="${this.selectedId}"]`).removeClass('active')
      $(`.review-button[data-id="${this.selectedId}"]`).removeClass('active')
    }

    this.selectedId = args.id
    $(`.review-block[data-id="${args.id}"]`).addClass('active')
    $(`.review-button[data-id="${args.id}"]`).addClass('active')

    if (args.context == 'content') {
      this.postMessage('highlight', { id: args.id })
    } else if (args.context == 'details' && args.refresh == 'true') {
      if (this.detailsIframe) this.detailsIframe.classList.add('active')
    } else {
      if (this.detailsIframe) this.detailsIframe.classList.remove('active')
    }
  },

  // Toggle the approved/rejected state for any reviewable block
  // Expected arguments:
  //   id      - the id of the block which should be toggled
  //   context - the context that this block belongs to which should be shown
  //   refresh - whether the details iframe should be reloaded
  toggleApproval(args) {
    const approved = !$(`.review-button[data-id="${args.id}"]`).hasClass('approved')
    $(`.review-button[data-id="${args.id}"]`).toggleClass('approved', approved)
    $(`.review-block[data-id="${args.id}"]`).toggleClass('approved', approved)

    if (args.context == 'content') {
      // This sends a message to the preview iframe to update the state of the block with the given id.
      // This allows us to have the preview dynamically change when a content change is approved/rejected.
      this.postMessage('approve', { id: args.id, approved: approved })
    } else if (args.context == 'details' && args.refresh == 'true') {
      // For detail changes, we instead reload the preview iframe, if refresh is set to true.
      const url = this.detailsIframe.src.split('?')[0]
      this.detailsIframe.src = `${url}?review=true&excerpt=true&reify=${this.getApprovedDetailChanges().join(',')}`
    }
  },

  // Send a message to the page's content preview.
  postMessage(action, data) {
    data.action = action
    data = JSON.parse(JSON.stringify(data))
    this.contentIframe.contentWindow.postMessage(data, '*')
  }

}

$(document).on('turbolinks:load', () => { Review.load() })
