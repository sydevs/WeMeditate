
class CustomMeditation {

  constructor(element) {
    this.container = element
    this.form = element.querySelector('.meditations__custom__form')
    this.goalSection = element.querySelector('.meditations__custom__goal')
    this.goalDropdown = this.goalSection.querySelector('.meditations__custom__goal__input')
    this.durationSection = element.querySelector('.meditations__custom__duration')
    this.durationRadioGroup = this.durationSection.querySelector('.radio_group')

    this.hasGoalValue = false
    this.hasDurationValue = false
    
    const radioButtons = element.querySelectorAll('input[type="radio"]')
    for (let index = 0; index < radioButtons.length; index++) {
      this.hasDurationValue = this.hasDurationValue || radioButtons[index].checked
      radioButtons[index].addEventListener('click', event => this._onDurationChange(event))
    }

    this.goalDropdown.addEventListener('change', event => this._onGoalChange(event))
    this.form.addEventListener('submit', event => this._onSubmit(event))
  }

  _onGoalChange(event) {
    this.goalDropdown.classList.remove('dropdown--error')
    this.hasGoalValue = true

    if (window.innerWidth < 768) {
      zenscroll.center(this.durationSection)
    } else {
      zenscroll.to(this.container)
    }
  }

  _onDurationChange(event) {
    this.durationRadioGroup.classList.remove('radio_group--error')
    this.hasDurationValue = true
  }

  _onSubmit(event) {
    let errorSection = null

    if (!this.hasDurationValue) {
      this.durationRadioGroup.classList.add('radio_group--error')
      errorSection = this.durationSection
    }
    
    if (!this.hasGoalValue) {
      this.goalDropdown.classList.add('dropdown--error')
      errorSection = this.goalSection
    }
    
    if (errorSection) {
      event.preventDefault()
      event.stopPropagation()

      if (window.innerWidth >= 768) {
        Application.header.scrollTo(this.container)
      } else {
        Application.header.scrollTo(errorSection, 100, 2000)
      }
    }
  }

}
