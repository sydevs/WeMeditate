
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
      settingsInputWrapper: `cdx-settings-input-zone`,
      settingsSelect: 'ce-settings-select',
      settingsInput: 'ce-settings-input',
      tunesWrapper: `ce-settings__tunes`,
      decorationsWrapper: `ce-settings__decorations`,
      decorationInputsWrapper: `ce-settings__inputs`,
      tuneButtons: {},
      decorationButtons: {},
      settings: {},
      fields: {},
      input: this.api.styles.input,
      inputs: {},
    }

    this.decorationsConfig = {
      triangle: {
        icon: 'counterclockwise rotated play',
        inputs: [
          { name: 'alignment', type: 'select', default: 'left', values: ['left', 'right'] },
        ],
      },
      gradient: {
        icon: 'counterclockwise rotated bookmark',
        inputs: [
          { name: 'alignment', type: 'select', default: 'left', values: ['left', 'right'] },
          { name: 'color', type: 'select', default: 'orange', values: ['orange', 'blue', 'gray'] },
        ],
      },
      sidetext: {
        icon: 'clockwise rotated heading',
        inputs: [
          { name: 'text', type: 'text', default: '' },
        ],
      },
      circle: { icon: 'circle outline' },
      leaves: { icon: 'leaf' },
    }

    for (let key in this.fields) {
      this.CSS.fields[key] = `cdx-${this.id}__${key}`
    }

    ['title', 'caption', 'textarea', 'text', 'content', 'button', 'url'].forEach(name => {
      this.CSS.inputs[name] = `${this.CSS.input}--${name}`
    })

    this.tunes.forEach(tune => {
      this.CSS.settings[tune.name] = `${this.CSS.container}--${tune.name}`
      this.CSS.tuneButtons[tune.name] = `${this.CSS.settingsButton}__${tune.name}`
      this.CSS.decorationButtons[tune.name] = `${this.CSS.settingsButton}__${tune.name}`
    })

    this.allowedDecorations.forEach(decoration => {
      this.CSS.decorationButtons[decoration] = `${this.CSS.settingsButton}__${decoration}`
    })
  }


  // =============== RENDERING =============== //

  // Create tool container with inputs
  render() {
    const container = make('div', [this.CSS.baseClass, this.CSS.container])

    for (let key in this.fields) {
      const field = this.fields[key]
      if (field.input === false) continue
      this.renderInput(key, container, field.contained)
    }

    this.tunes.forEach(tune => {
      container.classList.toggle(this.CSS.settings[tune.name], this.isTuneActive(tune))
    })

    if (this.allowDecoration) container.dataset.decorations = JSON.stringify(this.data.decorations)
    this.container = container
    return container
  }

  renderInput(key, container = null, contained = false) {
    let result
    let field = this.fields[key]
    let type = field.input || 'text'

    result = make('div', [this.CSS.input, this.CSS.inputs[type], this.CSS.fields[key]], {
      type: 'text',
      innerHTML: this.data[key],
      contentEditable: true,
    }, container)

    if (type == 'url') {
      result.addEventListener('blur', event => {
        const url = event.target.innerText
        if (url) event.target.innerText = (url.indexOf('://') === -1) ? 'http://' + url : url
      })
    }

    if (contained) {
      result.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event, false))
    }
    result.dataset.placeholder = field.label || translate['content']['placeholders'][key]

    return result
  }

  inhibitEnterAndBackspace(event, insertNewBlock = false) {
    if (event.key == 'Enter' || event.keyCode == 13) { // ENTER
      if (insertNewBlock) this.api.blocks.insert()
      event.stopPropagation()
      event.preventDefault()
      return false
    } else if (event.key == 'Backspace' || event.keyCode == 8) { // BACKSPACE
      event.stopPropagation()
      return false
    } else {
      return true
    }
  }


  // =============== SAVING =============== //

  // Extract data from tool element
  save(toolElement) {
    let newData = {}

    for (let key in this.fields) {
      newData[key] = toolElement.querySelector(`.${this.CSS.fields[key]}`).innerHTML
    }

    return Object.assign(this.data, newData)
  }


  // =============== SETTINGS =============== //

  // Create wrapper for Tool`s settings buttons.
  renderSettings() {
    const settingsContainer = make('div')

    make('label', '', { innerText: translate['content']['settings']['tunes'] }, settingsContainer)
    this.tunesWrapper = make('div', [this.CSS.settingsWrapper, this.CSS.tunesWrapper], {}, settingsContainer)
    this.renderTunes(this.tunesWrapper)

    make('label', '', { innerText: translate['content']['settings']['decorations'] }, settingsContainer)
    this.decorationsWrapper = make('div', [this.CSS.settingsWrapper, this.CSS.decorationsWrapper], {}, settingsContainer)
    this.renderDecorations(this.decorationsWrapper)

    this.inputsWrapper = make('div', [this.CSS.settingsWrapper, this.CSS.decorationInputsWrapper], {}, settingsContainer)
    this.renderDecorationInputs(this.inputsWrapper)

    this.updateSettingsButtons()
    return settingsContainer
  }

  updateSettingsButtons() {
    for (let i = 0; i < this.tunesWrapper.childElementCount; i++) {
      const element = this.tunesWrapper.children[i]
      const tune = this.tunes[i]
      element.classList.toggle(this.CSS.settingsButtonActive, this.isTuneActive(tune))
    }

    for (let i = 0; i < this.decorationsWrapper.childElementCount; i++) {
      const element = this.decorationsWrapper.children[i]
      const decorationKey = this.allowedDecorations[i]
      const selected = this.isDecorationSelected(decorationKey)
      element.classList.toggle(this.CSS.settingsButtonActive, selected)

      if (decorationKey == 'sidetext') {
        $(this.decorationInputs.sidetext.text).toggle(selected)
      } else if (decorationKey == 'triangle') {
        $(this.decorationInputs.triangle.alignment).toggle(selected)
      } else if (decorationKey == 'gradient') {
        $(this.decorationInputs.gradient.alignment).toggle(selected)
        $(this.decorationInputs.gradient.color).toggle(selected)
      }
    }
  }

  // ------ TUNES ------ //

  renderTunes(container) {
    this.tunes.map(tune => this.renderTuneButton(tune, container))

    for (let i = 0; i < container.childElementCount; i++) {
      const element = container.children[i]
      element.addEventListener('click', () => {
        if (!element.classList.contains(this.CSS.settingsButtonDisabled)) {
          this.selectTune(this.tunes[i])
          this.updateSettingsButtons()
        }
      })
    }
  }

  renderTuneButton(tune, container) {
    const button = make('div', [this.CSS.settingsButton, this.CSS.tuneButtons[tune.name]], null, container)
    button.dataset.position = 'top right'
    button.innerHTML = '<i class="'+tune.icon+' icon"></i>'

    if (tune.group) {
      button.dataset.tooltip = translate['content']['tunes'][tune.group][tune.name]
    } else {
      button.dataset.tooltip = translate['content']['tunes'][tune.name]
    }

    button.addEventListener('click', () => {
      if (!event.target.classList.contains(this.CSS.settingsButtonDisabled)) {
        this.selectTune(this.tune)
        this.updateSettingsButtons()
      }
    })

    if (this.isTuneActive(tune)) button.classList.add(this.CSS.settingsButtonActive)
    return button
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

    this.tunes
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
    this.tunesWrapper.querySelector(`.${this.CSS.settingsButtons[key]}`).classList.toggle(this.CSS.settingsButtonDisabled, !enabled)
  }

  // ------ DECORATIONS ------ //

  renderDecorations(container) {
    this.allowedDecorations.map(key => {
      const decoration = this.decorationsConfig[key]
      decoration.name = key
      this.renderDecorationButton(decoration, this.decorationsWrapper)
    })
  }

  renderDecorationButton(decoration, container) {
    const button = make('div', [this.CSS.settingsButton, this.CSS.decorationButtons[decoration.name]], null, container)
    button.dataset.position = 'top right'
    button.innerHTML = '<i class="'+decoration.icon+' icon"></i>'
    button.dataset.tooltip = translate['content']['decorations'][decoration.name]

    button.addEventListener('click', () => {
      if (!event.target.classList.contains(this.CSS.settingsButtonDisabled)) {
        this.setDecorationSelected(decoration.name, !this.isDecorationSelected(decoration.name))
        this.updateSettingsButtons()
      }
    })

    return button
  }

  renderDecorationInputs(container) {
    this.decorationInputs = {}

    this.allowedDecorations.map(key => {
      const decoration = this.decorationsConfig[key]

      if (decoration.inputs) {
        this.decorationInputs[key] = {}
        decoration.inputs.map(input => {
          this.decorationInputs[key][input.name] = this.renderDecorationInput(key, input, container)
        })
      }
    })
  }

  renderDecorationInput(key, input, container) {
    console.log('render', key, 'from', this.data.decorations)
    const value = (this.data.decorations && this.data.decorations[key] && this.data.decorations[key][input.name]) || input.default
    let result, inputElement

    if (input.type == 'select') {
      result = make('div', [this.CSS.settingsSelect, 'ui', 'inline', 'dropdown'], {}, container)
      inputElement = make('input', 'text', { type: 'hidden' }, result)
      make('div', 'text', { innerText: translate['content']['decorations'][`${key}_${input.name}`][value] }, result)
      make('i', ['dropdown', 'icon'], {}, result)
      const menu = make('div', 'menu', {}, result)
      input.values.map(val => {
        const label = translate['content']['decorations'][`${key}_${input.name}`][val]
        const item = make('div', 'item', { innerText: label }, menu)
        item.dataset.value = val
      })

      $(result).dropdown()
    } else {
      result = make('div', ['ui', 'transparent', 'input'], {}, container)
      inputElement = make('input', this.CSS.settingsInput, {
        type: input.type,
        placeholder: translate['content']['decorations'][`${key}_${input.name}`],
        value: value,
      }, result)
    }

    inputElement.addEventListener('change', event => this.setDecorationOption(key, input.name, event.target.value))

    result.style.display = 'none'
    return result
  }

  setDecorationSelected(key, selected) {
    if (!this.data.decorations) this.data.decorations = {}
    this.data.decorations[key] = selected
    console.trace('set', key, selected, this.data.decorations)
  }

  setDecorationOption(key, option, value) {
    console.log('setting', this.data.decorations.constructor, typeof this.data.decorations)
    if (this.data.decorations[key].constructor != Object) {
      this.data.decorations[key] = {}
    }
    
    this.data.decorations[key][option] = value
    console.log('set', key, option, '=', value, this.data.decorations[key])
  }

  isDecorationSelected(key) {
    return this.data.decorations && Boolean(this.data.decorations[key])
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
