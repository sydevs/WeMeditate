
class EditorTool {

  // Render plugin`s main Element and fill it with saved data
  constructor(data, config, api) {
    this.api = api
    this.data = data
    this.id = config.id
    this.allowDecoration = Boolean(config.decorations)
    this.allowedDecorations = config.decorations || []
    this.fields = config.fields || {}
    this.tunes = config.tunes || {}
    this.CSS = {
      baseClass: this.api.styles.block,
      container: `cdx-${this.id}`,
      settingsWrapper: `cdx-${this.id}-settings`,
      settingsButton: this.api.styles.settingsButton,
      settingsButtonActive: this.api.styles.settingsButtonActive,
      settingsButtonDisabled: `${this.api.styles.settingsButton}--disabled`,
      settingsSelect: 'ce-settings-select',
      settingsInput: 'ce-settings-input',
      settingsButtons: {},
      settings: {},
      fields: {},
      input: this.api.styles.input,
      inputs: {},
    }

    this.decorationsAttributes = {
      triangle: { title: 'Triangle', icon: 'counterclockwise rotated play' },
      gradient: { title: 'Gradient', icon: 'counterclockwise rotated bookmark' },
      sidetext: { title: 'Vertical Text', icon: 'clockwise rotated heading' },
      circle: { title: 'Circle', icon: 'circle outline' },
      leaves: { title: 'Leaves', icon: 'leaf' },
    }

    for (let key in this.fields) {
      this.CSS.fields[key] = `cdx-${this.id}__${key}`
    }

    ['title', 'caption', 'textarea', 'text', 'content', 'button', 'url'].forEach(name => {
      this.CSS.inputs[name] = `${this.CSS.input}--${name}`
    })

    this.tunes.forEach(tune => {
      this.CSS.settings[tune.name] = `${this.CSS.container}--${tune.name}`
      this.CSS.settingsButtons[tune.name] = `${this.CSS.settingsButton}__${tune.name}`
    })
  }


  // =============== RENDERING =============== //

  // Create tool container with inputs
  render() {
    const container = make('div', [this.CSS.baseClass, this.CSS.container])
    this.renderDecorations(container)

    for (let key in this.fields) {
      const field = this.fields[key]
      if (field.input === false) continue
      this.renderInput(key, container)
    }

    this.tunes.forEach(tune => {
      container.classList.toggle(this.CSS.settings[tune.name], this.isTuneActive(tune))
    })

    if (this.allowDecoration) container.dataset.decorations = JSON.stringify(this.data.decorations)
    this.container = container
    return container
  }

  renderInput(key, container = null) {
    let result
    let field = this.fields[key]
    let type = field.input || 'text'

    result = make('div', [this.CSS.input, this.CSS.inputs[type], this.CSS.fields[key]], {
      type: 'text',
      innerHTML: this.data[key],
      contentEditable: true,
    }, container)

    result.dataset.placeholder = field.label || translate['content']['placeholders'][key]

    return result
  }


  // =============== SAVING =============== //

  // Extract data from tool element
  save(toolElement) {
    let newData = {}

    for (let key in this.fields) {
      newData[key] = toolElement.querySelector(`.${this.CSS.fields[key]}`).innerHTML
    }

    if (this.allowDecoration) newData.decorations = this.getDecorationsData()
    return Object.assign(this.data, newData)
  }

  getDecorationsData() {
    const result = {}
    
    for (let index = 0; index < this.allowedDecorations.length; index++) {
      const key = this.allowedDecorations[index]

      if (this.isDecorationSelected(key) && this.allowedDecorations.indexOf(key) != -1) {
        if (key == 'triangle') {
          result[key] = { alignment: this.triangleAlignment.value }
        } else if (key == 'gradient') {
          result[key] = { alignment: this.gradientAlignment.value, color: this.gradientColor.value }
        } else if (key == 'sidetext') {
          result[key] = this.sidetextInput.value
        } else {
          result[key] = true
        }
      }
    }

    return result
  }


  // =============== SETTINGS =============== //

  // Create wrapper for Tool`s settings buttons.
  renderSettings() {
    this.settingsContainer = make('div', this.CSS.settingsWrapper)

    this.tunes.map(tune => {
      let label

      if (tune.group) {
        label = translate['content']['tunes'][tune.group][tune.name]
      } else {
        label = translate['content']['tunes'][tune.name]
      }

      const button = make('div', [this.CSS.settingsButton, this.CSS.settingsButtons[tune.name]], {
        title: label,
      }, this.settingsContainer)

      button.innerHTML = '<i class="'+tune.icon+' icon"></i>'

      if (this.isTuneActive(tune)) {
        button.classList.add(this.CSS.settingsButtonActive)
      }

      return button
    })

    for (let i = 0; i < this.settingsContainer.childElementCount; i++) {
      const element = this.settingsContainer.children[i]
      element.addEventListener('click', () => {
        if (!element.classList.contains(this.CSS.settingsButtonDisabled)) {
          this.selectTune(this.tunes[i])
          this.updateTuneButtons()
        }
      })
    }

    return this.settingsContainer
  }

  isTuneActive(tune) {
    return tune.group ? tune.name === this.data[tune.group] : this.data[tune.name] == true
  }

  selectTune(tune) {
    if (tune.group) {
      this.setTuneValue(tune.group, tune.name)
    } else {
      this.setTuneBoolean(tune.name, !this.data[tune.name])
    }

    return this.isTuneActive(tune)
  }

  setTuneValue(key, value) {
    this.container.classList.remove(this.CSS.settings[this.data[key]])
    this.data[key] = value
    this.container.classList.add(this.CSS.settings[value])
  }

  setTuneBoolean(key, value) {
    this.data[key] = value
    this.container.classList.toggle(this.CSS.settings[key], value)
  }

  setTuneEnabled(key, enabled) {
    this.settingsContainer.querySelector(`.${this.CSS.settingsButtons[key]}`).classList.toggle(this.CSS.settingsButtonDisabled, !enabled)
  }

  updateTuneButtons() {
    for (let i = 0; i < this.settingsContainer.childElementCount; i++) {
      const element = this.settingsContainer.children[i]
      const tune = this.tunes[i]
      element.classList.toggle(this.CSS.settingsButtonActive, this.isTuneActive(tune))
    }
  }

  // =============== DECORATIONS =============== //

  renderDecorations(container) {
    if (!this.allowDecoration) return

    this.decorationsButton = make('div', ['ce-toolbar__settings-btn', 'ce-toolbar__settings-btn--decorations'], {
      innerHTML: '<i class="leaf icon link"></i>'
    }, container)

    this.decorationsButton.addEventListener('click', () => { this.toggleDecorationsDropdown() })

    this.decorationsDropdown = make('div', ['ce-settings', 'ce-settings--decorations'], {}, container)
    const buttonWrapper = make('div', 'ce-settings__default-zone', {}, this.decorationsDropdown)

    this.decorationButtons = {}
    for (let index = 0; index < this.allowedDecorations.length; index++) {
      const key = this.allowedDecorations[index]
      this.decorationButtons[key] = this.renderDecorationsButton(key, buttonWrapper)
    }

    const inputWrapper = make('div', 'ce-settings__input-zone', {}, this.decorationsDropdown)
    let value

    if (this.allowedDecorations.indexOf('triangle') >= 0) {
      value = (this.data.decorations && this.data.decorations.triangle && this.data.decorations.triangle.alignment) || 'left'

      this.triangleAlignment = this.renderDecorationsSelect({
        left: 'Left Triangle',
        right: 'Right Triangle',
      }, value, inputWrapper)
    }

    if (this.allowedDecorations.indexOf('gradient') >= 0) {
      value = (this.data.decorations && this.data.decorations.gradient && this.data.decorations.gradient.alignment) || 'left'
      this.gradientAlignment = this.renderDecorationsSelect({
        left: 'Left Gradient',
        right: 'Right Gradient',
      }, value, inputWrapper)

      value = (this.data.decorations && this.data.decorations.gradient && this.data.decorations.gradient.color) || 'orange'
      this.gradientColor = this.renderDecorationsSelect({
        orange: 'Orange Gradient',
        blue: 'Blue Gradient',
        gray: 'Gray Gradient',
      }, value, inputWrapper)
    }

    if (this.allowedDecorations.indexOf('sidetext') >= 0) {
      this.sidetextInput = make('input', this.CSS.settingsInput, {
        type: 'unstyled',
        placeholder: 'Enter vertical text',
        value: (this.data.decorations && this.data.decorations.sidetext) || '',
      }, inputWrapper)
      this.sidetextInput.style.display = 'none'
    }

    for (let key in this.data.decorations) {
      this.setDecorationSelection(key, Boolean(this.data.decorations[key]))
    }
  }

  renderDecorationsButton(key, container = null) {
    const button = make('div', [this.CSS.settingsButton, `${this.CSS.settingsButton}--${key}`], {
      innerHTML: `<i class="${this.decorationsAttributes[key].icon} icon"></i>`,
      title: this.decorationsAttributes[key].title,
    }, container)

    button.addEventListener('click', () => this.setDecorationSelection(key, !this.isDecorationSelected(key)))
    return button
  }

  renderDecorationsSelect(options, selected = null, container = null) {
    const optionsHTML = []
    for (let key in options) {
      if (key == selected) {
        optionsHTML.push(`<option selected="selected" value="${key}">${options[key]}</option>`)
      } else {
        optionsHTML.push(`<option value="${key}">${options[key]}</option>`)
      }
    }

    const select = make('select', this.CSS.settingsSelect, {
      innerHTML: optionsHTML.join(''),
    }, container)

    select.style.display = 'none'
    return select
  }

  toggleDecorationsDropdown(open = null) {
    if (open === null) open = !this.decorationsDropdown.classList.contains('ce-settings--opened')
    const dismissDecorations = () => { this.toggleDropdown(false) }

    if (open) {
      document.addEventListener('click', dismissDecorations)
    } else {
      document.removeEventListener('click', dismissDecorations)
    }

    this.decorationsDropdown.classList.toggle('ce-settings--opened', open)
  }

  isDecorationSelected(slug) {
    return this.decorationButtons[slug].classList.contains(this.CSS.settingsButtonActive)
  }

  isAnyDecorationSelected() {
    for (let index = 0; index < this.allowedDecorations.length; index++) {
      const key = this.allowedDecorations[index]
      if (this.isDecorationSelected(key)) return true
    }

    return false
  }

  setDecorationSelection(slug, selected) {
    if (this.allowedDecorations.indexOf(slug) == -1) return
    this.decorationButtons[slug].classList.toggle(this.CSS.settingsButtonActive, selected)

    if (slug == 'sidetext') {
      $(this.sidetextInput).toggle(selected)
    } else if (slug == 'triangle') {
      $(this.triangleAlignment).toggle(selected)
    } else if (slug == 'gradient') {
      $(this.gradientAlignment).toggle(selected)
      $(this.gradientColor).toggle(selected)
    }

    this.decorationsButton.classList.toggle(this.CSS.settingsButtonActive, this.isAnyDecorationSelected())
  }
}

function make(tagName, classNames = null, attributes = {}, parent = null) {
  let el = document.createElement(tagName);

  if ( Array.isArray(classNames) ) {
    el.classList.add(...classNames);
  } else if ( classNames ) {
    el.classList.add(classNames);
  }

  for (let attrName in attributes) {
    el[attrName] = attributes[attrName];
  }

  if (parent) {
    parent.appendChild(el)
  }

  return el;
}
