
class Prescreen {

  constructor(element) {
    this.container = element
    this.abbreviation = element.querySelector('abbr')
    this.explanation = element.querySelector('.prescreen__explanation-wrapper')

    this.abbreviation.addEventListener('click', () => this._onClickAbbreviation())
  }

  _onClickAbbreviation() {
    this.explanation.classList.toggle('prescreen__explanation-wrapper--opened')
    //this.abbreviation.classList.toggle('prescreen__abbr--active')
  }

}
