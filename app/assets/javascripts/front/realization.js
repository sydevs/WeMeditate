/* global zenscroll, $, jwplayer, Util */
/* exported Realization */

class Realization {

  constructor(element) {
    this.container = element
    
    this.display = this.container.dataset.screen
    history.pushState({ screen: this.display }, '', `/meditations/first-experience/${this.display}`)
    window.addEventListener('popstate', () => this.checkDisplay())

    this.desktopVideo = element.querySelector('.js-video-desktop')
    this.mobileVideo = element.querySelector('.js-video-mobile')
    this.surveyOptions = element.querySelectorAll('input[name="survey[]"]')
    this.surveyInput = element.querySelector('input[name="signup[survey]"]')
    this.changeableInputs = element.querySelectorAll('input[data-for]')
    this.form = element.querySelector('form')
    this.submitButton = element.querySelector('button[type=submit]')
    
    this.form.addEventListener('ajax:send', (_event, _xhr) => this.formSending())
    this.form.addEventListener('ajax:success', (_event, _data, _status, _xhr) => this.formSuccess())
    this.form.addEventListener('ajax:error', (_event, _xhr, _status, _error) => this.formError())

    const actions = element.querySelectorAll('[data-goto]')
    for (let i = 0; i < actions.length; i++) {
      actions[i].addEventListener('click', event => this.displayScreen(event.currentTarget.dataset.goto))
    }

    element.querySelector('.js-permalink').addEventListener('focus', event => {
      event.currentTarget.select()
      event.currentTarget.setSelectionRange(0, 99999) // For mobile
      document.execCommand('copy')
    })
  }

  _scrollTo(target) {
    return // Temporarily disable this

    if (!zenscroll) return // Return if zenscroll isn't defined
    let el = document.getElementById(target)
    zenscroll.toY(zenscroll.getTopOf(el) - 35)
  }

  checkDisplay() {
    let slug = window.location.pathname.split('/')[3] || 'ready'
    this.displayScreen(slug)
  }

  displayScreen(screen) {
    if (this.display == screen) return // Do nothing if it's the same screen.

    if (this.display == 'video') {
      this.player.pause() // Pause video if not already paused.
    }

    if (this.display == 'survey') {
      let surveyValue = []

      for (let i = 0; i < this.surveyOptions.length; i++) {
        const option = this.surveyOptions[i]
        if (option.checked) {
          surveyValue.push(option.value)
        }
      }

      this.surveyInput.value = surveyValue.join(',')
    }

    this.display = screen
    this.container.dataset.screen = this.display
    history.pushState({ screen: this.display }, '', `/meditations/first-experience/${this.display}`)

    if (this.display == 'video') {
      if (!this.player) {
        const isDesktop = $(this.desktopVideo).is(':visible')
        const videoId = isDesktop ? 'botr_1oDJAjaD_8SfP7aMx_div' : 'botr_8FivThod_NaHiexhY_div'
        this.player = this.loadJWPlayer(videoId)
      }

      this.player.play()
    }

    // Disable any form inputs which aren't for the current screen.
    const inputs = this.changeableInputs
    for (let i = 0; i < inputs.length; i++) {
      inputs[i].disabled = (inputs[i].dataset.for != this.display)
    }

    this._scrollTo('#realization')
  }

  loadJWPlayer(div) {
    const player = jwplayer(div)
    player.on('pause', () => this.displayScreen('paused'))
    player.on('complete', () => this.displayScreen('survey'))
    return player
  }

  formSending() {
    this.submitButton.innerText = 'Loading...'
  }

  formSuccess() {
    this.displayScreen('thanks')
  }

  formError() {
    this.submitButton.innerText = 'Try Again...'
  }

  share() {
    const shareData = {
      title: document.title,
      text: 'Experience Self Realization',
      url: window.location.href
    }

    if (navigator.share) {
      Util.share(shareData)
    } else {
      this.shareBtnsContainer.classList.add('realization__share__button-wrapper--open')
      Util.shareFallback(shareData, this.shareBtns)
    }
  }

}