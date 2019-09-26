
const Review = {

  load() {
    console.log('Load Review.js')
    this.selectedId = null
    this.$detailsReview = $('#details-review')
    this.detailsIframe = document.getElementById('details-iframe')
    this.$contentReview = $('#content-review')
    this.contentIframe = document.getElementById('content-iframe')

    //this.menuScroller = zenscroll.createScroller(document.getElementById('review-menu').firstChild, 1000, 50)
    $('#review-form').on('submit', event => this.storeReviewData())
    $('.review-button').on('mouseenter', event => this.highlightBlock(event.currentTarget.dataset))
    $('.review-button:not(.disabled)').on('click', event => this.toggleApproval(event.currentTarget.dataset))

    if (this.detailsIframe) {
      this.detailsIframe.addEventListener('load', function() {
        this.style.height = (this.contentWindow.document.body.scrollHeight + 10) + 'px'
      })
    }
  },

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

  getApprovedDetailChanges() {
    result = []

    $('.review-button[data-context="details"]').each(function(index, element) {
      if (element.classList.contains('approved')) {
        result.push(element.dataset.id)
      }
    })

    return result
  },

  showContext(context) {
    const $from = (context == 'details') ? this.$contentReview : this.$detailsReview
    const $to = (context == 'details') ? this.$detailsReview : this.$contentReview
    if ($from.css('display') == 'none') {
      $to.fadeIn('fast')
    } else {
      $from.fadeOut('fast', () => $to.fadeIn('fast'))
    }
  },

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

  toggleApproval(args) {
    const approved = !$(`.review-button[data-id="${args.id}"]`).hasClass('approved')
    $(`.review-button[data-id="${args.id}"]`).toggleClass('approved', approved)
    $(`.review-block[data-id="${args.id}"]`).toggleClass('approved', approved)

    if (args.context == 'content') {
      this.postMessage('approve', { id: args.id, approved: approved })
    } else if (args.context == 'details' && args.refresh == 'true') {
      const url = this.detailsIframe.src.split("?")[0]
      this.detailsIframe.src = `${url}?review=true&excerpt=true&reify=${this.getApprovedDetailChanges().join(',')}`
    }
  },

  postMessage(action, data) {
    data['action'] = action
    data = JSON.parse(JSON.stringify(data))
    this.contentIframe.contentWindow.postMessage(data, '*')
  }

}

$(document).on('turbolinks:load', () => { Review.load() })
