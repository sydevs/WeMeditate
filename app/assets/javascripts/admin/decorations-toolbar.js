
const DecorationsToolbar = {
  CSS: {
    container: 'ce-settings--decorations',
    menuButton: 'ce-toolbar__settings-btn',
    settingsButton: 'cdx-settings-button',
    settingsButtonActive: 'cdx-settings-button--active',
    settingsSelect: 'ce-settings-select',
    settingsInput: 'ce-settings-input',
  },

  icons: {
    triangle: 'counterclockwise rotated play',
    gradient: 'counterclockwise rotated bookmark',
    sidetext: 'clockwise rotated heading',
  },

  load(editor) {
    console.log('loading DecorationsToolbar.js', editor)
    this.button = make('div', this.CSS.menuButton, { innerHTML: '<i class="leaf icon link"></i>' })
    this.button.addEventListener('click', () => this.toggleDropdown())
    editor.querySelector('.ce-toolbar__actions-buttons').append(this.button)

    this.dropdown = this.renderDropdown()
    editor.querySelector('.ce-toolbar__actions').append(this.dropdown)
  },

  toggleDropdown(open = null) {
    if (open === null) open = !this.dropdown.classList.contains('ce-settings--opened')
    const currentBlock = Editor.getCurrentBlock()

    if (open) {
      this.setData(JSON.parse(currentBlock.dataset.decorations))
      document.addEventListener('click', DecorationsToolbar._onClickDocument)
    } else {
      currentBlock.dataset.decorations = JSON.stringify(this.getData())
      document.removeEventListener('click', DecorationsToolbar._onClickDocument)
    }

    this.dropdown.classList.toggle('ce-settings--opened', open)
  },

  isDecorationSelected(slug) {
    return this.decorationButtons[slug].classList.contains(this.CSS.settingsButtonActive)
  },

  setDecorationSelection(slug, selected) {
    this.decorationButtons[slug].classList.toggle(this.CSS.settingsButtonActive, selected)

    if (slug == 'sidetext') {
      $(this.sidetextInput).toggle(selected)
    } else if (slug == 'triangle') {
      $(this.triangleAlignment).toggle(selected)
    } else if (slug == 'gradient') {
      $(this.gradientAligment).toggle(selected)
      $(this.gradientColor).toggle(selected)
    }
  },

  _onClickDocument(event) {
    if (event.target.closest(`.${DecorationsToolbar.CSS.menuButton}`) !== DecorationsToolbar.button && event.target.closest(`.${DecorationsToolbar.CSS.container}`) === null) {
      DecorationsToolbar.toggleDropdown(false)
    }
  },

  renderDropdown() {
    const container = make('div', ['ce-settings', this.CSS.container])
    const buttonWrapper = make('div', 'ce-settings__default-zone', {}, container)

    this.decorationButtons = {
      triangle: this.renderDropdownButton('triangle', 'Triangle', buttonWrapper),
      gradient: this.renderDropdownButton('gradient', 'Gradient', buttonWrapper),
      sidetext: this.renderDropdownButton('sidetext', 'Vertical Title', buttonWrapper),
    }

    const inputWrapper = make('div', 'ce-settings__input-zone', {}, container)

    this.triangleAlignment = this.renderDropdownSelect({
      left: 'Left Triangle',
      right: 'Right Triangle',
    }, inputWrapper)

    this.gradientAligment = this.renderDropdownSelect({
      left: 'Left Gradient',
      right: 'Right Gradient',
    }, inputWrapper)

    this.gradientColor = this.renderDropdownSelect({
      orange: 'Orange Gradient',
      blue: 'Blue Gradient',
      gray: 'Gray Gradient',
    }, inputWrapper)

    this.sidetextInput = make('input', this.CSS.settingsInput, {
      type: 'unstyled',
      placeholder: 'Enter vertical text'
    }, inputWrapper)
    this.sidetextInput.style.display = 'none'

    return container
  },

  renderDropdownButton(slug, title, container) {
    const button = make('div', [this.CSS.settingsButton, `${this.CSS.settingsButton}--${slug}`], {
      innerHTML: `<i class="${this.icons[slug]} icon"></i>`,
      title: title,
    }, container)

    button.addEventListener('click', () => this.setDecorationSelection(slug, !this.isDecorationSelected(slug)))
    return button
  },

  renderDropdownSelect(options, container) {
    const optionsHTML = []
    const select = make('select', this.CSS.settingsSelect, {}, container)

    for (key in options) {
      optionsHTML.push(`<option value="${key}">${options[key]}</option>`)
    }

    select.innerHTML = optionsHTML.join('')
    select.style.display = 'none'
    return select
  },

  getData() {
    const result = {}
    if (this.isDecorationSelected('sidetext')) {
      result.sidetext = this.sidetextInput.value
    }

    if (this.isDecorationSelected('triangle')) {
      result.triangle = {
        alignment: this.triangleAlignment.value,
      }
    }

    if (this.isDecorationSelected('gradient')) {
      result.gradient = {
        alignment: this.gradientAligment.value,
        color: this.gradientColor.value,
      }
    }

    return result
  },

  setData(data) {
    this.setDecorationSelection('sidetext', data.sidetext)
    if (data.sidetext) {
      this.sidetextInput.value = data.sidetext || ''
    }

    this.setDecorationSelection('triangle', data.triangleAlignment)
    if (data.triangle) {
      this.triangleAlignment.value = data.triangle.alignment || 'left'
    }

    this.setDecorationSelection('gradient', data.gradient)
    if (data.gradient) {
      this.gradientAligment.value = data.gradient.alignment || 'left'
      this.gradientColor.value = data.gradient.color || 'orange'
    }
  },

}
