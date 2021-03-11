import $ from 'jquery'
import { translate, make } from '../util'

/** Editor Tool
 * This folder contains definitions for each type of block which can be used in our content editor.
 * This file contains the super class for all those tools, providing common functionality between them all.
 */

export default class EditorTool {

  constructor(data, config, api) {
    this.api = api // Save a reference to the EditorJS api
    this.data = data // Save data for this tool/block
    this.id = config.id // Save the id of this block, so that we can recognize if it changes
    this.allowDecoration = Boolean(config.decorations) // Check the configuration as to whether decorations are defined for this tool.

    this.allowedDecorations = config.decorations || []
    this.fields = config.fields || {}
    this.tunes = config.tunes || []

    // Set up tunes data
    Object.keys(this.tunes).forEach(key => {
      this.tunes[key].name = key
      this.tunes[key].options.map(tune => {
        tune.group = key
        return tune
      })
    })

    console.log(this.tunes)
    
    // A convenience to lookup the CSS classes used in the editor
    this.CSS = {
      baseClass: this.api.styles.block,
      container: `cdx-${this.id}`,
      optionsWrapper: 'cdx-options',
      optionsGroup: 'cdx-options__group',
      optionsGroupActive: 'cdx-options__group--active',
      optionsButton: this.api.styles.settingsButton,
      optionsButtonActive: this.api.styles.settingsButtonActive,
      optionsButtonDisabled: `${this.api.styles.settingsButton}--disabled`,
      optionsInputWrapper: 'cdx-settings-input-zone',
      optionsSelect: 'ce-settings-select',
      settingsInput: 'ce-settings-input',
      semanticInput: 'cdx-semantic-input',
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
    for (const key in this.tunes) {
      const group = this.tunes[key]
      for (let i = 0; i < group.options.length; i++) {
        const tune = group.options[i]
        this.CSS.tunes[tune.name] = `${this.CSS.container}--${tune.name}`
        this.CSS.tuneButtons[tune.name] = `${this.CSS.optionsButton}__${tune.name}`
      }
    }

    // For each decoration used by this tool, save CSS classes
    this.allowedDecorations.forEach(decoration => {
      this.CSS.decorationButtons[decoration] = `${this.CSS.optionsButton}__${decoration}`
    })
  }


  // =============== RENDERING =============== //

  // Creates the tool html with inputs
  render() {
    const container = make('div', [this.CSS.baseClass, this.CSS.container])

    // Render the fields which are defined for this tool
    for (let key in this.fields) {
      const field = this.fields[key]
      if (field.input === false) continue
      this.renderInput(key, container)
    }

    // Add the classes for any active tunes
    for (const key in this.tunes) {
      const group = this.tunes[key]
      for (let i = 0; i < group.options.length; i++) {
        const tune = group.options[i]
        container.classList.toggle(this.CSS.tunes[tune.name], this.isTuneActive(tune))
      }
    }

    // Render the settings block
    this.renderOptions(container)
    //make('div', [this.CSS.optionsWrapper], {}, container)

    this.container = container // Save a reference to the container
    console.log(container)
    return container
  }

  // Renders a standard type of input
  renderInput(key, container = null) {
    let result
    let field = this.fields[key]
    let type = field.input || 'text'

    result = make('div', [this.CSS.input, this.CSS.inputs[type]], {
      type: 'text',
      innerHTML: this.data[key],
      contentEditable: true,
    }, container)

    result.dataset.key = key

    if (type == 'url') {
      // URL inputs should auto-prepend an HTTP protocol if no protocol is defined.
      result.addEventListener('blur', event => {
        const url = event.target.innerText
        if (url) event.target.innerText = (url.indexOf('://') === -1) ? 'http://' + url : url
      })
    }

    if (type == 'text' && field.contained != false) {
      // Text fields should prevent EditorJS from splitting pasted content into multiple blocks
      result.addEventListener('paste', event => this.containPaste(event))
    }

    if (field.contained) {
      // Any field wiith the contained attriibute set should prevent enter/backspace from creating/deleting blocks.
      result.addEventListener('keydown', event => this.inhibitEnterAndBackspace(event, false))
    }

    // Add the field's label as a placeholder, or use a default placeholder
    result.dataset.placeholder = field.label || translate().content.placeholders[key]

    if (field.optional) {
      // If this field is optional append that to the placeholder
      result.dataset.placeholder += ` (${translate().content.placeholders.optional})`
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
      document.execCommand('insertHTML', false, '\r\n')
      event.preventDefault()
      event.stopPropagation()
      return false
    }
  }

  // Paste content directly into the tool, bypassing EditorJS's normal behaviour.
  containPaste(event) {
    const clipboardData = event.clipboardData || window.clipboardData
    const pastedData = clipboardData.getData('Text')
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

  // Create the options menu for this tool.

  renderOptions(container = null) {
    const settingsContainer = make('div', [this.CSS.optionsWrapper], {}, container)

    // Render tunes if there is at least one defined.
    if (Object.keys(this.tunes).length > 0) {
      console.log('rendering tunes', this.tunes)
      //make('label', '', { innerText: translate().content.settings.tunes }, settingsContainer)
      this.tunesWrapper = make('div', '', {}, settingsContainer)
      this.renderTunes(this.tunesWrapper)
    }

    // Render decorations if there is at least one allowed.
    /*
    if (this.allowedDecorations.length > 0) {
      make('label', '', { innerText: translate().content.settings.decorations }, settingsContainer)
      this.decorationsWrapper = make('div', [this.CSS.optionsWrapper, this.CSS.decorationsWrapper], {}, settingsContainer)
      this.renderDecorations(this.decorationsWrapper)

      // Render decoration inputs
      this.inputsWrapper = make('div', [this.CSS.optionsWrapper, this.CSS.decorationInputsWrapper], {}, settingsContainer)
      this.renderDecorationInputs(this.inputsWrapper)
    }
    */

    // Lastly, update the settings buttons to reflect the current state of the block.
    this.updateOptionsButtons()
    return settingsContainer
  }

  // Create this tool's settings menu.
  renderSettingsBlock(container = null) {
    const settingsContainer = make('div', null, null, container)

    // Render tunes if there is at least one defined.
    if (Object.keys(this.tunes).length > 0) {
      console.log('rendering tunes', this.tunes)
      //make('label', '', { innerText: translate().content.settings.tunes }, settingsContainer)
      this.tunesWrapper = make('div', [this.CSS.settingsWrapper], {}, settingsContainer)
      this.renderTunes(this.tunesWrapper)
    }

    // Render decorations if there is at least one allowed.
    /*
    if (this.allowedDecorations.length > 0) {
      make('label', '', { innerText: translate().content.settings.decorations }, settingsContainer)
      this.decorationsWrapper = make('div', [this.CSS.settingsWrapper, this.CSS.decorationsWrapper], {}, settingsContainer)
      this.renderDecorations(this.decorationsWrapper)

      // Render decoration inputs
      this.inputsWrapper = make('div', [this.CSS.settingsWrapper, this.CSS.decorationInputsWrapper], {}, settingsContainer)
      this.renderDecorationInputs(this.inputsWrapper)
    }
    */

    // Lastly, update the settings buttons to reflect the current state of the block.
    //this.updateOptionsButtons()
    //return settingsContainer
  }

  // Updates the appearance of all settings buttons and inputs to reflect the current state of the block.
  updateOptionsButtons() {
    console.log('update option buttons', this.data)

    if (this.tunesWrapper) {
      // If tunes are defined, updated them
      for (const key in this.tunes) {
        const group = this.tunes[key]
        const groupWrapper = this.tunesWrapper.querySelector(`.${this.CSS.optionsGroup}[data-key=${key}]`)
        const isActive = this.isTuneGroupActive(group)
        groupWrapper.classList.toggle(this.CSS.optionsGroupActive, isActive)
        groupWrapper.querySelector('label').dataset.value = this.data[group.name]
        
        if (isActive) {
          for (let i = 0; i < group.options.length; i++) {
            const tune = group.options[i]
            const tuneButton = groupWrapper.querySelector(`.${this.CSS.optionsButton}[data-key=${tune.name}]`)
            tuneButton.classList.toggle(this.CSS.optionsButtonActive, this.isTuneActive(tune))
          }
        }
      }
    }

    /*
    if (this.decorationsWrapper) {
      // If decorations are defined, updated them
      for (let i = 0; i < this.decorationsWrapper.childElementCount; i++) {
        const element = this.decorationsWrapper.children[i]
        const decorationKey = this.allowedDecorations[i]
        const selected = this.isDecorationSelected(decorationKey)
        element.classList.toggle(this.CSS.optionsButtonActive, selected)

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
    */
  }

  // ------ TUNES ------ //

  // Render the set of tune buttons
  renderTunes(container) {
    // Render a button for each tune
    Object.keys(this.tunes).forEach(key => {
      const group = this.tunes[key]
      group.name = key
      this.renderTuneGroup(group, container)
    })
  }

  renderTuneGroup(group, container) {
    const optionsGroup = make('div', this.CSS.optionsGroup, {}, container)
    optionsGroup.dataset.key = group.name

    if (group.requires) {
      optionsGroup.dataset.requiresKey = Object.keys(group.requires)[0]
      optionsGroup.dataset.requiresValue = Object.values(group.requires)[0]
    }

    make('label', '', { innerText: group.name }, optionsGroup)
    group.options.forEach(tune => {
      tune.group = group.name
      this.renderTuneButton(tune, optionsGroup)
    })
  }

  // Renders one tune button
  renderTuneButton(tune, container) {
    const button = make('div', [this.CSS.optionsButton], null, container)
    button.dataset.position = 'top right'
    button.dataset.group = tune.group
    button.dataset.key = tune.name
    button.innerHTML = '<i class="' + tune.icon + ' icon"></i>'

    //button.dataset.tooltip = tune.name.toUpper()
    /*
    if (group) {
      button.dataset.tooltip = translate().content.tunes[group.name][tune.name]
    } else {
      button.dataset.tooltip = translate().content.tunes[tune.name]
    }
    */

    button.addEventListener('click', () => {
      if (!event.currentTarget.classList.contains(this.CSS.optionsButtonDisabled)) {
        this.selectTune(tune)
        this.updateOptionsButtons()
      }
    })

    if (this.isTuneActive(tune)) button.classList.add(this.CSS.optionsButtonActive)
    return button
  }

  // Check if a tune if currently selected.
  isTuneGroupActive(group) {
    console.log('check group active', group, !group.requires, this.data[group.name])
    if (!group.requires) return true

    for (const key in group.requires) {
      const value = group.requires[key]
      return this.data[key] === value
    }
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
    this.tunesWrapper.querySelector(`.${this.CSS.tuneButtons[key]}`).classList.toggle(this.CSS.optionsButtonDisabled, !enabled)
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
    const button = make('div', [this.CSS.optionsButton, this.CSS.decorationButtons[decoration.name]], null, container)
    button.dataset.position = 'top right'
    button.innerHTML = '<i class="' + decoration.icon + ' icon"></i>'
    button.dataset.tooltip = translate().content.decorations[decoration.name]

    button.addEventListener('click', () => {
      if (!event.target.classList.contains(this.CSS.optionsButtonDisabled)) {
        this.setDecorationSelected(decoration, !this.isDecorationSelected(decoration.name))
        this.updateOptionsButtons()
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
      result = make('div', [this.CSS.optionsSelect, 'ui', 'inline', 'dropdown'], {}, container)
      inputElement = make('input', 'text', { type: 'hidden' }, result)
      make('div', 'text', { innerText: translate().content.decorations[`${key}_${input.name}`][value] }, result)
      make('i', ['dropdown', 'icon'], {}, result)
      const menu = make('div', 'menu', {}, result)
      input.values.forEach(val => {
        const label = translate().content.decorations[`${key}_${input.name}`][val]
        const item = make('div', 'item', { innerText: label }, menu)
        item.dataset.value = val
      })

      $(result).dropdown()
    } else {
      result = make('div', ['ui', 'transparent', 'input'], {}, container)
      inputElement = make('input', this.CSS.settingsInput, {
        type: input.type,
        placeholder: translate().content.decorations[`${key}_${input.name}`],
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
