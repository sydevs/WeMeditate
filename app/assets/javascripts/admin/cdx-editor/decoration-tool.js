
class DecorationTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="leaf icon"></i>',
      title: 'Decoration',
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      title: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      text: data.text || '',
      size: ['small', 'medium', 'large'].includes(data.size) ? data.size : 'medium',
      color: ['orange', 'blue'].includes(data.color) ? data.color : 'orange',
      alignment: ['left', 'right'].includes(data.alignment) ? data.alignment : 'left',
      format: ['triangle', 'gradient', 'sidetext'].includes(data.format) ? data.format : 'triangle',
    }, { // Config
      id: 'decoration',
      fields: {
        text: { label: 'Enter some vertical text', input: 'title' },
        size: { input: false },
        color: { input: false },
      },
      tunes: [
        {
          name: 'triangle',
          label: 'Triangle',
          icon: 'counterclockwise rotated play',
          group: 'format',
        },
        {
          name: 'gradient',
          label: 'Gradient',
          icon: 'counterclockwise rotated bookmark',
          group: 'format',
        },
        {
          name: 'sidetext',
          label: 'Vertical Title',
          icon: 'clockwise rotated heading',
          group: 'format',
        },
        {
          name: 'left',
          label: 'Left Aligned',
          icon: 'align left',
          group: 'alignment',
        },
        {
          name: 'right',
          label: 'Right Aligned',
          icon: 'align right',
          group: 'alignment',
        },
      ],
    }, api)

    this.CSS.fieldsContainer = `${this.CSS.container}-fields`
    this.CSS.gradient = `${this.CSS.container}__gradient`
    this.CSS.triangle = `${this.CSS.container}__triangle`
    this.CSS.preview = `${this.CSS.container}__preview`
  }

  render() {
    const container = super.render()

    const fieldsContainer = make('div', this.CSS.fieldsContainer, { innerHTML: container.innerHTML })
    container.innerHTML = null
    container.append(fieldsContainer)

    const sizeInput = make('select', this.CSS.fields.size, {}, fieldsContainer)
    make('option', null, { value: 'small', innerText: 'Small' }, sizeInput)
    make('option', null, { value: 'medium', innerText: 'Medium' }, sizeInput)
    make('option', null, { value: 'large', innerText: 'Large' }, sizeInput)
    sizeInput.addEventListener('change', event => this.applySize(event.target.value))
    sizeInput.querySelector(`[value="${this.data.size}"]`).setAttribute('selected', 'selected')
    this.applySize(this.data.size)

    const colorInput = make('select', this.CSS.fields.color, {}, fieldsContainer)
    make('option', null, { value: 'orange', innerText: 'Orange' }, colorInput)
    make('option', null, { value: 'blue', innerText: 'Blue' }, colorInput)
    colorInput.addEventListener('change', event => this.applyColor(event.target.value))
    colorInput.querySelector(`[value="${this.data.color}"]`).setAttribute('selected', 'selected')
    this.applyColor(this.data.color)

    const gradient = make('div', [this.CSS.gradient, this.CSS.preview])
    container.prepend(gradient)

    const triangle = make('div', [this.CSS.triangle, this.CSS.preview], { innerHTML: `<img src="${Editor.triangle_path}"></img>` })
    container.prepend(triangle)

    make('div', '', { style: 'clear: both' }, container)

    return container
  }

  applySize(value) {
    this.container.classList.remove(`${this.CSS.container}--${this.sizeValue}`)
    this.sizeValue = value
    this.container.classList.add(`${this.CSS.container}--${this.sizeValue}`)
  }

  applyColor(value) {
    this.container.classList.remove(`${this.CSS.container}--${this.colorValue}`)
    this.colorValue = value
    this.container.classList.add(`${this.CSS.container}--${this.colorValue}`)
  }

  save() {

  }

  // Empty Decoration is not empty Block
  static get contentless() {
    return false;
  }
}
