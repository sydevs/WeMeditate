
class Form {

  constructor(element) {
    this.container = element
    this.message = element.querySelector('.content__form__message')
    this.type = element.classList.contains('content__form--signup') ? 'signup' : 'contact'

    if (this.container.dataset.remote) {
      this.container.addEventListener('ajax:beforeSend', _event => this.setLoadingState(true))
    }
  }

  setMessage(message, type = 'positive') {
    const oppositeType = (type == 'positive' ? 'negative' : 'positive')
    this.message.classList.remove(`content__form__message--${oppositeType}`)
    this.message.classList.add(`content__form__message--${type}`)
    this.message.innerText = message
    $(this.message).show()
  }

  setLoadingState(isLoading) {
    const inputs = this.container.querySelectorAll('input, textarea, select')
    const buttons = this.container.querySelectorAll('.button')

    this.container.classList.toggle('form--loading', isLoading)

    if (isLoading) {
      for (let index = 0; index < inputs.length; index++) {
        inputs[index].setAttribute('disabled', 'disabled')
      }

      for (let index = 0; index < buttons.length; index++) {
        buttons[index].classList.add('button--disabled')
        buttons[index].setAttribute('disabled', 'disabled')
      }

      this.setMessage('Loading...')
    } else {
      for (let index = 0; index < inputs.length; index++) {
        inputs[index].removeAttribute('disabled')
      }

      for (let index = 0; index < buttons.length; index++) {
        buttons[index].classList.remove('button--disabled')
        buttons[index].removeAttribute('disabled')
      }
    }
  }

}
