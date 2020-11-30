/* global zenscroll, $, jwplayer, Util */
/* exported Realization */

class Realization {

  constructor(element) {
    this.container = element
    this.readyBtn = element.querySelector('.js-ready-button')
    this.readyRemindBtn = element.querySelector('.js-ready-remind-link')
    this.pausedBtn = element.querySelector('.js-paused-button')
    this.pausedFinishBtn = element.querySelector('.js-paused-finish-link')
    this.remindBtn = element.querySelector('.js-remind-button')
    this.remindBackBtn = element.querySelector('.js-remind-back-link')
    this.surveyBtns = element.querySelectorAll('.js-survey-button')
    this.surveyMsg = element.querySelector('.js-survey-message')
    this.surveyNextBtn = element.querySelector('.js-survey-next-link')
    this.courseBtn = element.querySelector('.js-course-button')
    this.thanksBtn = element.querySelector('.js-thanks-button')
    this.shareBtnsContainer = element.querySelector('.js-share-button-wrapper')
    this.shareBtns = element.querySelectorAll('.js-share-button')

    this.desktopVideo = element.querySelector('.js-video-desktop')
    this.mobileVideo = element.querySelector('.js-video-mobile')

    this.courseForm = element.querySelector('.js-course-form')
    this.courseFeelInput = this.courseForm.querySelector('#signup_properties')

    this.remindForm = element.querySelector('.js-remind-form')

    this.courseForm.addEventListener('ajax:send', (_event, _xhr) => this.formSending(this.courseBtn))
    this.courseForm.addEventListener('ajax:success', (_event, _data, _status, _xhr) => this.formSuccess(this.courseBtn))
    this.courseForm.addEventListener('ajax:error', (_event, _xhr, _status, _error) => this.formError(this.courseBtn))
    this.remindForm.addEventListener('ajax:send', (_event, _xhr) => this.formSending(this.remindBtn))
    this.remindForm.addEventListener('ajax:success', (_event, _data, _status, _xhr) => this.formSuccess(this.remindBtn))
    this.remindForm.addEventListener('ajax:error', (_event, _xhr, _status, _error) => this.formError(this.remindBtn))

    this.display = this.container.dataset.screen
    history.pushState({ screen: this.display }, '', `/meditations/first-experience/${this.display}`)
    
    this.readyBtn.addEventListener('click', () => this.displayScreen('video'))
    this.readyRemindBtn.addEventListener('click', () => this.displayScreen('remind'))
    this.pausedBtn.addEventListener('click', () => this.displayScreen('video'))
    this.pausedFinishBtn.addEventListener('click', () => this.displayScreen('survey'))
    this.remindBackBtn.addEventListener('click', () => this.displayScreen('ready'))
    this.surveyNextBtn.addEventListener('click', () => this.passFeel())
    this.thanksBtn.addEventListener('click', () => this.share())
    
    for (let i = 0; i < this.surveyBtns.length; i++) {
      const surveyBtn = this.surveyBtns[i]
      surveyBtn.addEventListener('click', () => surveyBtn.classList.toggle('button--active'))
    }

    window.addEventListener('popstate', () => this.checkDisplay())
    
    if (typeof zenscroll !== 'undefined') {
      this._scrollTo(this.display)
    }

  }

  _scrollTo(target) {
    let el = document.getElementById(target)
    zenscroll.toY(zenscroll.getTopOf(el) - 35)
  }

  checkDisplay() {
    let slug = window.location.pathname.split('/')[3] || 'ready'
    this.container.dataset.screen = slug
  }

  displayScreen(screen) {
    this.display = screen
    this.container.dataset.screen = this.display
    history.pushState({ screen: this.display }, '', `/meditations/first-experience/${this.display}`)

    if (this.display == 'video') {
      if ($(this.desktopVideo).is(':visible')) {
        jwplayer('botr_1oDJAjaD_8SfP7aMx_div').on('ready', this.loadJWPlayer('botr_1oDJAjaD_8SfP7aMx_div'))
        jwplayer('botr_1oDJAjaD_8SfP7aMx_div').play()
      } else {
        jwplayer('botr_8FivThod_NaHiexhY_div').on('ready', this.loadJWPlayer('botr_8FivThod_NaHiexhY_div'))
        jwplayer('botr_8FivThod_NaHiexhY_div').play()
      }
    }

    this._scrollTo(this.display)
  }

  loadJWPlayer(div) {
    let player = jwplayer(div)
    this.display = 'video'

    player.on('pause', () => {
      this.displayScreen('paused')
    })

    player.on('complete', () => {
      this.displayScreen('survey')
    })

    this._scrollTo(this.display)
  }

  passFeel() {
    let feelings = []
    let feelFlag = false
    for (let i = 0; i < this.surveyBtns.length; i++) {
      let surveyBtn = this.surveyBtns[i]
      if (surveyBtn.classList.contains('button--active')) {
        feelFlag = true
        feelings.push(surveyBtn.id)
      }
    }
    if (feelFlag) {
      let props = { feel: feelings }
      this.displayScreen('course')
      this.courseFeelInput.value = JSON.stringify(props)
    } else {
      $(this.surveyMsg).show()
    }
  }

  formSending(btn) {
    btn.innerText = 'Loading...'
  }

  formSuccess(btn) {
    this.displayScreen('thanks')

    if (btn == this.courseBtn) {
      btn.innerText = 'Get my course'
    } else if (btn == this.remindBtn) {
      btn.innerText = 'Send'
    }
  }

  formError(btn) {
    btn.innerText = 'Try Again...'
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
      this.shareFallback(shareData)
    }
  }

  shareFallback(shareData) {
    this.shareBtnsContainer.classList.add('realization__share__button-wrapper--open')
    Util.shareFallback(shareData, this.shareBtns)
  }

}