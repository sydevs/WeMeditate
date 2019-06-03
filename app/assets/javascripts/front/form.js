
class Form {

  constructor(element) {
    this.container = element

    if (this.container.dataset.remote) {
      this.container.addEventListener('ajax:beforeSend', _event => this.setLoadingState(true))
    }
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

      const message = this.container.querySelector('.content__form__message')
      message.classList.remove('content__form__message--negative')
      message.classList.add('content__form__message--positive')
      message.innerText = 'Loading...'
      $(message).show()
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
