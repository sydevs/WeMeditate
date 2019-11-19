/* global $, translate */
/* exported EditorTool */

/** Editor Tool
 * This folder contains definitions for each type of block which can be used in our content editor.
 * This file contains the super class for all those tools, providing common functionality between them all.
 */

class EditorTool {

  constructor(data, config, api) {
    this.api = api // Save a reference to the EditorJS api
    this.data = data // Save data for this tool/block
    this.id = config.id // Save the id of this block, so that we can recognize if it changes
    this.allowDecoration = Boolean(config.decorations) // Check the configuration as to whether decorations are defined for this tool.

    this.allowedDecorations = config.decorations || []
    this.fields = config.fields || {}
    this.tunes = config.tunes || []
    
    // A convenience to lookup the CSS classes used in the editor
    this.CSS = {
      baseClass: this.api.styles.block,
      container: `cdx-${this.id}`,
      settingsWrapper: `cdx-${this.id}-settings`,
      settingsButton: this.api.styles.settingsButton,
      settingsButtonActive: this.api.styles.settingsButtonActive,
      settingsButtonDisabled: `${this.api.styles.settingsButton}--disabled`,
      settingsInputWrapper: 'cdx-settings-input-zone',
      settingsSelect: 'ce-settings-select',
      settingsInput: 'ce-settings-input',
      semanticInput: 'cdx-semantic-input',
      tunesWrapper: 'ce-settings__tunes',
      decorationsWrapper: 'ce-settings__decorations',
      decorationInputsWrapper: 'ce-settings__inputs',
      tuneButtons: {},
      decorationButtons: {},
      tunes: {},
      fields: {},
      input: this.api.styles.input,
      inputs: {},
    }

    // The standard configurations for different types of block decorations
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

    // For every field used by this tool, save a CSS class
    for (let key in this.fields) {
      this.CSS.fields[key] = `cdx-${this.id}__${key}`
    }

    // A few special types of inputs also have their own CSS class
    ['title', 'caption', 'textarea', 'text', 'content', 'button', 'url'].forEach(name => {
      this.CSS.inputs[name] = `${this.CSS.input}--${name}`
    })

    // For each tune used by this tool, save CSS classes
    this.tunes.forEach(tune => {
      this.CSS.tunes[tune.name] = `${this.CSS.container}--${tune.name}`
      this.CSS.tuneButtons[tune.name] = `${this.CSS.settingsButton}__${tune.name}`
    })

    // For each decoration used by this tool, save CSS classes
    this.allowedDecorations.forEach(decoration => {
      this.CSS.decorationButtons[decoration] = `${this.CSS.settingsButton}__${decoration}`
    })
  }


  // =============== RENDERING =============== //

  // Creates the tool html with inputs
  render() {
    const container = Util.make('div', [this.CSS.baseClass, this.CSS.container])

    // Render the fields which are defined for this tool
    for (let key in this.fields) {
      const field = this.fields[key]
      if (field.input === false) continue
      this.renderInput(key, container)
    }

    // Add the classes for any active tunes
    this.tunes.forEach(tune => {
      container.classList.toggle(this.CSS.tunes[tune.name], this.isTuneActive(tune))
    })

    this.container = container // Save a reference to the container
    return container
  }

  // Renders a standard type of input
  renderInput(key, container = null) {
    let result
    let field = this.fields[key]
    let type = field.input || 'text'

    result = Util.make('div', [this.CSS.input, this.CSS.inputs[type], this.CSS.fields[key]], {
      type: 'text',
      innerHTML: this.data[key],
      contentEditable: true,
    }, container)

    if (type == 'url') {
      // URL inputs should auto-prepend an HTTP protocol if no protocol is defined.
      result.addEventListener('blur', event => {
        const url = event.target.innerText
        if (url) event.target.innerText = (url.indexOf('://') === -1) ? 'http://' + url : url
      })
    }

    if (type == 'text') {
      // Text fields should prevent EditorJS from splitting pasted content into multiple blocks
      result.addEventListener('paste', event => this.containPaste(event))
    }

    if (field.contained) {
      // Any field wiith the contained attriibute set should prevent enter/backspace from creating/deleting blocks.
      result.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event, false))
    }

    // Add the field's label as a placeholder, or use a default placeholder
    result.dataset.placeholder = field.label || translate.content.placeholders[key]

    if (field.optional) {
      // If this field is optional append that to the placeholder
      result.dataset.placeholder += ` (${translate.content.placeholders.optional})`
    }

    return result
  }

  // This prevents the default EditorJS behaviour for the enter and backspace buttons
  inhibitEnterAndBackspace(event, insertNewBlock = false) {
    if (event.key == 'Enter' || event.keyCode == 13) { // ENTER
      if (insertNewBlock) this.api.blocks.insert() // Insert a block if allowed
      event.stopPropagation()
      event.preventDefault()
      return false
    } else if (event.key == 'Backspace' || event.keyCode == 8) { // BACKSPACE
      event.stopImmediatePropagation()
      return false
    } else {
      return true
    }
  }

  // This will insert a paragraph break if the enter button is pressed.
  insertParagraphBreak(event) {
    if (event.key == 'Enter' || event.keyCode == 13) { // ENTER
      document.execCommand('insertHTML', false, '<br><br>')
      event.preventDefault()
      event.stopPropagation()
      return false
    }
  }

  // Converts anny pasted content to use <br> tags, and pastes it directly into the tool, bypassing EditorJS's normal behaviour.
  containPaste(event) {
    const clipboardData = event.clipboardData || window.clipboardData
    const pastedData = clipboardData.getData('Text').replace(/(?:\r\n|\r|\n)/g, '<br>')
    document.execCommand('insertHTML', false, pastedData)
    event.stopPropagation()
    event.preventDefault()
    return false
  }


  // =============== SAVING =============== //

  // Extract data from the tool element, so that it can be saved.
  save(toolElement) {
    let newData = {}

    // Get the contents of each field for this tool.
    for (let key in this.fields) {
      newData[key] = toolElement.querySelector(`.${this.CSS.fields[key]}`).innerHTML
      newData[key] = newData[key].replace('&nbsp;', ' ').trim() // Stip non-breaking whitespace
    }

    return Object.assign(this.data, newData)
  }


  // =============== SETTINGS =============== //

  // Create this tool's settings menu.
  renderSettings() {
    const settingsContainer = Util.make('div')

    // Render tunes if there is at least one defined.
    if (this.tunes.length > 0) {
      Util.make('label', '', { innerText: translate.content.settings.tunes }, settingsContainer)
      this.tunesWrapper = Util.make('div', [this.CSS.settingsWrapper, this.CSS.tunesWrapper], {}, settingsContainer)
      this.renderTunes(this.tunesWrapper)
    }

    // Render decorations if there is at least one allowed.
    if (this.allowedDecorations.length > 0) {
      Util.make('label', '', { innerText: translate.content.settings.decorations }, settingsContainer)
      this.decorationsWrapper = Util.make('div', [this.CSS.settingsWrapper, this.CSS.decorationsWrapper], {}, settingsContainer)
      this.renderDecorations(this.decorationsWrapper)

      // Render decoration inputs
      this.inputsWrapper = Util.make('div', [this.CSS.settingsWrapper, this.CSS.decorationInputsWrapper], {}, settingsContainer)
      this.renderDecorationInputs(this.inputsWrapper)
    }

    // Lastly, update the settings buttons to reflect the current state of the block.
    this.updateSettingsButtons()
    return settingsContainer
  }

  // Updates the appearance of all settings buttons and inputs to reflect the current state of the block.
  updateSettingsButtons() {
    if (this.tunesWrapper) {
      // If tunes are defined, updated them
      for (let i = 0; i < this.tunesWrapper.childElementCount; i++) {
        const element = this.tunesWrapper.children[i]
        const tune = this.tunes[i]
        element.classList.toggle(this.CSS.settingsButtonActive, this.isTuneActive(tune))
      }
    }

    if (this.decorationsWrapper) {
      // If decorations are defined, updated them
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
  }

  // ------ TUNES ------ //

  // Render the set of tune buttons
  renderTunes(container) {
    // Render a button for each tune
    this.tunes.map(tune => this.renderTuneButton(tune, container))
  }

  // Renders one tune button
  renderTuneButton(tune, container) {
    const button = Util.make('div', [this.CSS.settingsButton, this.CSS.tuneButtons[tune.name]], null, container)
    button.dataset.position = 'top right'
    button.innerHTML = '<i class="' + tune.icon + ' icon"></i>'

    if (tune.group) {
      button.dataset.tooltip = translate.content.tunes[tune.group][tune.name]
    } else {
      button.dataset.tooltip = translate.content.tunes[tune.name]
    }

    button.addEventListener('click', () => {
      if (!event.currentTarget.classList.contains(this.CSS.settingsButtonDisabled)) {
        this.selectTune(tune)
        this.updateSettingsButtons()
      }
    })

    if (this.isTuneActive(tune)) button.classList.add(this.CSS.settingsButtonActive)
    return button
  }

  // Check if a tune if currently selected.
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
    this.container.classList.remove(this.CSS.tunes[this.data[key]])
    this.data[key] = value
    this.container.classList.add(this.CSS.tunes[value])
  }

  setTuneBoolean(key, value) {
    this.data[key] = value
    this.container.classList.toggle(this.CSS.tunes[key], value)
  }

  setTuneEnabled(key, enabled) {
    this.tunesWrapper.querySelector(`.${this.CSS.tuneButtons[key]}`).classList.toggle(this.CSS.settingsButtonDisabled, !enabled)
  }

  // ------ DECORATIONS ------ //

  renderDecorations(_container) {
    this.allowedDecorations.forEach(key => {
      const decoration = this.decorationsConfig[key]
      decoration.name = key
      this.renderDecorationButton(decoration, this.decorationsWrapper)
    })
  }

  renderDecorationButton(decoration, container) {
    const button = Util.make('div', [this.CSS.settingsButton, this.CSS.decorationButtons[decoration.name]], null, container)
    button.dataset.position = 'top right'
    button.innerHTML = '<i class="' + decoration.icon + ' icon"></i>'
    button.dataset.tooltip = translate.content.decorations[decoration.name]

    button.addEventListener('click', () => {
      if (!event.target.classList.contains(this.CSS.settingsButtonDisabled)) {
        this.setDecorationSelected(decoration, !this.isDecorationSelected(decoration.name))
        this.updateSettingsButtons()
      }
    })

    return button
  }

  renderDecorationInputs(container) {
    this.decorationInputs = {}

    this.allowedDecorations.forEach(key => {
      const decoration = this.decorationsConfig[key]

      if (decoration.inputs) {
        this.decorationInputs[key] = {}
        decoration.inputs.forEach(input => {
          this.decorationInputs[key][input.name] = this.renderDecorationInput(key, input, container)
        })
      }
    })
  }

  renderDecorationInput(key, input, container) {
    const value = (this.data.decorations && this.data.decorations[key] && this.data.decorations[key][input.name]) || input.default
    let result, inputElement

    if (input.type == 'select') {
      result = Util.make('div', [this.CSS.settingsSelect, 'ui', 'inline', 'dropdown'], {}, container)
      inputElement = Util.make('input', 'text', { type: 'hidden' }, result)
      Util.make('div', 'text', { innerText: translate.content.decorations[`${key}_${input.name}`][value] }, result)
      Util.make('i', ['dropdown', 'icon'], {}, result)
      const menu = Util.make('div', 'menu', {}, result)
      input.values.forEach(val => {
        const label = translate.content.decorations[`${key}_${input.name}`][val]
        const item = Util.make('div', 'item', { innerText: label }, menu)
        item.dataset.value = val
      })

      $(result).dropdown()
    } else {
      result = Util.make('div', ['ui', 'transparent', 'fluid', 'input'], {}, container)
      inputElement = Util.make('input', this.CSS.settingsInput, {
        type: input.type,
        placeholder: translate.content.decorations[`${key}_${input.name}`],
        value: value,
      }, result)
    }

    inputElement.addEventListener('change', event => this.setDecorationOption(key, input.name, event.target.value))

    result.style.display = 'none'
    return result
  }

  setDecorationSelected(decoration, selected) {
    if (!this.data.decorations) this.data.decorations = {}

    if (decoration.inputs && selected) {
      if (!this.data.decorations[decoration.name] || this.data.decorations[decoration.name].constructor != Object) {
        const data = {}
        decoration.inputs.forEach(input => { data[input.name] = input.default })
        this.data.decorations[decoration.name] = data
      }
    } else {
      this.data.decorations[decoration.name] = selected
    }
  }

  setDecorationOption(key, option, value) {
    if (this.data.decorations[key].constructor != Object) {
      this.data.decorations[key] = {}
    }
    
    this.data.decorations[key][option] = value
  }

  isDecorationSelected(key) {
    return this.data.decorations && Boolean(this.data.decorations[key])
  }
}
