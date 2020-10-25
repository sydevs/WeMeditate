/* global zenscroll, $ */
/* exported Realization */

class Realization {

  constructor(element) {
    this.container = element
    this.introBtn = element.querySelector('.intro__button')
    this.readyBtn = element.querySelector('.ready__button')
    this.readyRemindBtn = element.querySelector('.ready__remind__link')
    this.pausedBtn = element.querySelector('.paused__button')
    this.pausedFinishBtn = element.querySelector('.paused__finish__link')
    this.remindBtn = element.querySelector('.remind__button')
    this.remindBackBtn = element.querySelector('.remind__back__link')
    this.surveyBtns = element.querySelectorAll('.survey__button')
    this.surveyMsg = element.querySelector('.survey__message')
    this.surveyNextBtn = element.querySelector('.survey__next__link')
    this.courseBtn = element.querySelector('.course__button')
    this.thanksBtn = element.querySelector('.thanks__button')
    this.shareBtnsContainer = element.querySelector('.share__button-wrapper')
    this.shareBtns = element.querySelectorAll('.share__button')

    this.desktopVideo = element.querySelector('.sr__video__frame--desktop')
    this.mobileVideo = element.querySelector('.sr__video__frame--mobile')

    this.courseForm = element.querySelector('.course__form')
    this.courseFormMsg = this.courseForm.querySelector('.course__form__message')
    this.courseFeelInput = this.courseForm.querySelector('#signup_properties')

    this.remindForm = element.querySelector('.remind__form')
    this.remindFormMsg = element.querySelector('.remind__form__message')

    this.courseForm.addEventListener('ajax:send', (event, xhr) => this.formSending(this.courseBtn))
    this.courseForm.addEventListener('ajax:success', (event, data, status, xhr) => this.formSuccess())
    this.courseForm.addEventListener('ajax:error', (event, xhr, status, error) => this.formError())
    this.remindForm.addEventListener('ajax:send', (event, xhr) => this.formSending(this.remindBtn))
    this.remindForm.addEventListener('ajax:success', (event, data, status, xhr) => this.formSuccess())
    this.remindForm.addEventListener('ajax:error', (event, xhr, status, error) => this.formError())

    this.target = 'intro'
    
    this.introBtn.addEventListener('click', () => this.nextScreen(this.introBtn))
    this.readyBtn.addEventListener('click', () => this.nextScreen(this.readyBtn))
    this.readyRemindBtn.addEventListener('click', () => this.nextScreen(this.readyRemindBtn))
    this.pausedBtn.addEventListener('click', () => this.nextScreen(this.pausedBtn))
    this.pausedFinishBtn.addEventListener('click', () => this.nextScreen(this.pausedFinishBtn))
    this.remindBackBtn.addEventListener('click', () => this.nextScreen(this.remindBackBtn))
    this.surveyNextBtn.addEventListener('click', () => this.passFeel())
    this.thanksBtn.addEventListener('click', () => this.share())
    
    for (let i = 0; i < this.surveyBtns.length; i++) {
      const surveyBtn = this.surveyBtns[i]
      surveyBtn.addEventListener('click', () => surveyBtn.classList.toggle('button--active'))
    }
    
    if (typeof zenscroll !== 'undefined') {
      this._scrollTo(this.target)
    }

  }

  _scrollTo(target) {
    let el = document.getElementById(target)
    zenscroll.toY(zenscroll.getTopOf(el) - 30)
  }

  nextScreen(btn) {
    switch (btn) {
      case this.introBtn:
        this.target = 'ready'
        this.container.dataset.screen = this.target
        break
      case this.readyBtn:
        this.target = 'video'
        this.container.dataset.screen = this.target
        if ($(this.desktopVideo).is(':visible')) {
          // this.loadDesktopPlayer()
          jwplayer("botr_1oDJAjaD_8SfP7aMx_div").on('ready', this.loadJWPlayer("botr_1oDJAjaD_8SfP7aMx_div"))
          jwplayer("botr_1oDJAjaD_8SfP7aMx_div").play()
        } else {
          // this.loadMobilePlayer()
          jwplayer("botr_8FivThod_NaHiexhY_div").on('ready', this.loadJWPlayer("botr_8FivThod_NaHiexhY_div"))
          jwplayer("botr_8FivThod_NaHiexhY_div").play()
        }
        break
      case this.readyRemindBtn:
        this.target = 'remind'
        this.container.dataset.screen = this.target
        break
      case this.pausedBtn:
        this.target = 'video'
        this.container.dataset.screen = this.target
        break
      case this.pausedFinishBtn:
        this.target = 'survey'
        this.container.dataset.screen = this.target
        break
      case this.remindBackBtn:
        this.target = 'ready'
        this.container.dataset.screen = this.target
        break
      default:
        break
    }

    this._scrollTo(this.target)

  }

  loadDesktopPlayer() {
    let jwConfig = {
      "aspectratio": "16:10",
      "autostart": false,
      "cast": {
        "appid": "00000000"
      },
      "controls": true,
      "displaydescription": true,
      "displaytitle": true,
      "flashplayer": "//ssl.p.jwpcdn.com/player/v/8.17.7/jwplayer.flash.swf",
      "height": 360,
      "key": "tlbC+HgyRBgC8seKreQwmghcO2P9nQ4y+l4ZeKQEfzpgOSzuT9f5+N0odL4=",
      "mute": false,
      "ph": 3,
      "pid": "8SfP7aMx",
      "playbackRateControls": false,
      "playlist": "//cdn.jwplayer.com/v2/media/1oDJAjaD?recommendations_playlist_id=xFiJh22s",
      "preload": "metadata",
      "repeat": false,
      "stagevideo": false,
      "stretching": "uniform",
      "width": "100%"
    }
    jwplayer("desktopVideo").setup(jwConfig)

    let player = jwplayer("desktopVideo")
    this.target = 'video'

    player.on('pause', () => {
      this.target = 'paused'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)
    })

    player.on('complete', () => {
      this.target = 'survey'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)
    })

    this._scrollTo(this.target)
  }

  loadMobilePlayer() {
    let jwConfig = {
      "aspectratio": "9:16",
      "autostart": false,
      "cast": {
        "appid": "00000000"
      },
      "controls": true,
      "displaydescription": false,
      "displaytitle": false,
      "flashplayer": "//ssl.p.jwpcdn.com/player/v/8.17.7/jwplayer.flash.swf",
      "height": 360,
      "key": "G4TQ74H6dL+J2s9zjsY53y72/VJdEKk5UO4K8F3CL4mUDDFs7Wl6siOex5c=",
      "mute": false,
      "ph": 3,
      "pid": "NaHiexhY",
      "playbackRateControls": false,
      "playlist": "//cdn.jwplayer.com/v2/media/8FivThod?recommendations_playlist_id=xFiJh22s",
      "preload": "metadata",
      "repeat": false,
      "stagevideo": false,
      "stretching": "uniform",
      "width": "100%"
    }
    jwplayer("mobileVideo").setup(jwConfig)

    let player = jwplayer("mobileVideo")
    this.target = 'video'

    player.on('pause', () => {
      this.target = 'paused'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)
    })

    player.on('complete', () => {
      this.target = 'survey'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)
    })

    this._scrollTo(this.target)
  }

  loadJWPlayer(div) {
    let player = jwplayer(div)
    this.target = 'video'

    player.on('pause', () => {
      this.target = 'paused'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)
    })

    player.on('complete', () => {
      this.target = 'survey'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)
    })

    this._scrollTo(this.target)
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
      let props = {
        "feel": feelings
      }
      this.target = 'course'
      this.container.dataset.screen = this.target
      this._scrollTo(this.target)

      this.courseFeelInput.value = JSON.stringify(props)
    } else {
      $(this.surveyMsg).show()
    }
  }

  formSending(btn) {
    btn.innerText = 'Loading...'
  }

  formSuccess() {
    this.target = 'thanks'
    this.container.dataset.screen = this.target
  }

  formError() {
    console.log("Error in form submission...")
  }

  share() {
    const shareData = {
      title: document.title,
      text: 'Experience Self Realization',
      url: window.location.href
    }
    if (navigator.share) {
      navigator.share(shareData)
        .then(() => console.log('Successful share'))
        .catch((error) => console.log('Error sharing...', error))
    } else {
      this.shareFallback(shareData)
    }
  }

  shareFallback(shareData) {
    this.shareBtnsContainer.classList.add('share__button-wrapper--open')
    
    for (let i = 0; i < this.shareBtns.length; i++) {
      const button = this.shareBtns[i]
      let href = button.href
      href = href.replace('{url}', encodeURIComponent(shareData.url))
      href = href.replace('{title}', encodeURIComponent(shareData.title))
      href = href.replace('{text}', encodeURIComponent(shareData.text))
      href = href.replace('{provider}', encodeURIComponent(window.location.hostname))
      button.href = href
    }
  }

}