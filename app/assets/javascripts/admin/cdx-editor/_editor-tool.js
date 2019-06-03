
class EditorTool {

  // Render plugin`s main Element and fill it with saved data
  constructor(data, config, api) {
    this.api = api
    this.data = data
    this.id = config.id
    this.allowDecoration = Boolean(config.decorations)
    this.fields = config.fields || {}
    this.tunes = config.tunes || {}
    this.CSS = {
      baseClass: this.api.styles.block,
      container: `cdx-${this.id}`,
      settingsWrapper: `cdx-${this.id}-settings`,
      settingsButton: this.api.styles.settingsButton,
      settingsButtonActive: this.api.styles.settingsButtonActive,
      settingsButtonDisabled: `${this.api.styles.settingsButton}--disabled`,
      settingsButtons: {},
      settings: {},
      fields: {},
      input: this.api.styles.input,
      inputs: {},
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

    result.dataset.placeholder = field.label

    return result
  }

  // =============== SAVING =============== //

  // Extract data from tool element
  save(toolElement) {
    let newData = {}

    for (let key in this.fields) {
      newData[key] = toolElement.querySelector(`.${this.CSS.fields[key]}`).innerHTML
    }

    if (this.allowDecoration) newData.decorations = JSON.parse(this.container.dataset.decorations)
    return Object.assign(this.data, newData)
  }


  // =============== SETTINGS =============== //

  // Create wrapper for Tool`s settings buttons.
  renderSettings() {
    this.settingsContainer = make('div', this.CSS.settingsWrapper)

    this.tunes.map(tune => {
      const button = make('div', [this.CSS.settingsButton, this.CSS.settingsButtons[tune.name]], {
        title: tune.label,
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
    console.log('set tune enabled', key, enabled, 'on', this.CSS.settingsButtons[key], 'in', this.settingsContainer, '-', this.settingsContainer.querySelector(this.CSS.settingsButtons[key]))
    this.settingsContainer.querySelector(`.${this.CSS.settingsButtons[key]}`).classList.toggle(this.CSS.settingsButtonDisabled, !enabled)
  }

  updateTuneButtons() {
    for (let i = 0; i < this.settingsContainer.childElementCount; i++) {
      const element = this.settingsContainer.children[i]
      const tune = this.tunes[i]
      element.classList.toggle(this.CSS.settingsButtonActive, this.isTuneActive(tune))
    }
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
