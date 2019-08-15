// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require semantic-ui
//= require data-confirm-modal-semantic-ui

class Review {

  constructor() {
    console.log('Init Review.js')
    this.selectedId = null
    this.menuScroller = zenscroll.createScroller(document.getElementById('review-menu').firstChild, 1000, 50)
    this.approvalsCount = $('.approved.review-block').length
    $('#review-form').on('submit', event => this.storeReviewData())
    $('.review-button').on('mouseenter', event => this.highlightBlock(event.currentTarget.dataset.id, 'menu'))
    $('.review-block-handle').on('mouseenter', event => this.highlightBlock(event.currentTarget.dataset.id, 'block'))
    $('.review-button:not(.disabled), .review-block-handle:not(.disabled)').on('click', event => this.toggleApproval(event.currentTarget.dataset.id))
    this.disableInteractions()

    $('.review-actions > .positive.button > span').text(` (${this.approvalsCount})`)
  }

  storeReviewData() {
    const data = []
    $('#review-menu .review-button').each(function(index, element) {
      const effect = element.classList.contains('approved') ? element.dataset.effect : 'nochange'
      data.push({ id: element.dataset.id, effect: effect })
    })

    $('#review-input').val(JSON.stringify(data))
  }

  disableInteractions() {
    $('body > *:not(#review-menu)').children('a, button, input, select').on('click', function(event) {
      event.preventDefault()
      event.stopPropagation()
      return false
    }).on('focus', function(event) {
      event.target.blur()
      event.preventDefault()
      event.stopPropagation()
      return false
    }).css('cursor', 'not-allowed')
  }

  highlightBlock(id, source) {
    if (this.selectedId) {
      $(`.review-block[data-id="${this.selectedId}"]`).removeClass('active')
      $(`.review-button[data-id="${this.selectedId}"]`).removeClass('active')
    }

    this.selectedId = id
    const block = document.querySelector(`.review-block[data-id="${id}"]`)
    const button = document.querySelector(`.review-button[data-id="${id}"]`)
    block.classList.add('active')
    button.classList.add('active')

    if (source == 'menu') {
      zenscroll.center(block, 1000)
    } else {
      this.menuScroller.intoView(button, 1000)
    }
  }

  toggleApproval(id) {
    const approved = document.querySelector(`.review-button[data-id="${id}"]`).classList.toggle('approved')
    document.querySelector(`.review-block[data-id="${id}"]`).classList.toggle('approved', approved)
    this.approvalsCount = this.approvalsCount + (approved ? +1 : -1)
    $('.review-actions > .positive.button > span').text(` (${this.approvalsCount})`)
  }

}

document.addEventListener('ready', () => { new Review() })
