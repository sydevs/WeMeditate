import $ from 'jquery'
import { translate } from '../../i18n'

export default class Form {

  constructor(element) {
    this.container = element
    this.button = element.querySelector('.button')
    this.message = element.querySelector('.cb-form-action__message')
    this.type = element.classList.contains('cb-form-action--signup') ? 'signup' : 'contact'
    this.originalButtonText = this.button.innerText

    if (this.container.dataset.remote) {
      this.container.addEventListener('ajax:beforeSend', _event => this.setLoadingState(true))
      this.container.addEventListener('ajax:error', _event => {
        this.setMessage(translate('error'), 'negative')
        this.setButtonEnabled(true)
        this.setLoadingState(false)
      })
    }

    const inputs = this.container.querySelectorAll('input, textarea, select')
    for (let index = 0; index < inputs.length; index++) {
      inputs[index].addEventListener('input', () => {
        this.setButtonEnabled(true)
        this.setButtonText(this.originalButtonText)
      })
    }
  }

  setMessage(message, type = 'positive') {
    const oppositeType = (type == 'positive' ? 'negative' : 'positive')
    this.message.classList.remove(`cb-form-action__message--${oppositeType}`)
    this.message.classList.add(`cb-form-action__message--${type}`)
    this.message.innerText = message
    $(this.message).show()
  }

  setButtonText(text) {
    this.button.innerText = text
  }

  setButtonEnabled(enabled) {
    if (enabled) {
      this.button.removeAttribute('disabled')
      this.button.classList.remove('button--disabled')
    } else {
      this.button.setAttribute('disabled', 'disabled')
      this.button.classList.add('button--disabled')
    }
  }

  setLoadingState(isLoading) {
    const inputs = this.container.querySelectorAll('input, textarea, select')
    this.container.classList.toggle('cb-form-action--loading', isLoading)

    if (isLoading) {
      for (let index = 0; index < inputs.length; index++) {
        inputs[index].setAttribute('disabled', 'disabled')
      }

      this.setButtonEnabled(false)
      this.setMessage(translate('loading'))
    } else {
      for (let index = 0; index < inputs.length; index++) {
        inputs[index].removeAttribute('disabled')
      }
    }
  }

}
