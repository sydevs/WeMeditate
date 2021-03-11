import { generateId } from '../util'
import EditorTool from './_editor-tool'

export default class TextTool extends EditorTool {

  // Sanitizer data before saving
  static get sanitize() {
    return {
      text: {},
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || generateId(),
      text: data.text || '',
      type: ['text', 'heading', 'quote', 'blockquote'].includes(data.type) ? data.type : 'text',
      level: ['h2', 'h3', 'h4'].includes(data.type) ? data.type : 'h2',
    }, { // Config
      id: 'text',
      fields: {
        text: { label: '', contained: false },
      },
      tunes: {
        type: {
          options: [
            { name: 'text', icon: 'font', },
            { name: 'header', icon: 'heading' },
          ]
        },
        level: {
          requires: { type: 'header' },
          options: [
            { name: 'h2', icon: 'heading' },
            { name: 'h3', icon: 'heading' },
            { name: 'h4', icon: 'heading' },
          ]
        },
      },
    }, api)

    this.onKeyUp = this.onKeyUp.bind(this)
  }

  // Check if text content is empty and set empty string to inner html.
  // We need this because some browsers (e.g. Safari) insert <br> into empty contenteditanle elements
  onKeyUp(event) {
    if (event.code !== 'Backspace' && event.code !== 'Delete') {
      return
    }

    if (this.container.textContent === '') {
      this.container.innerHTML = ''
    }
  }

  // How to merge with another text element.
  merge(data) {
    this.data = { text: this.data.text + data.text }
  }

  onPaste(event) {
    this.data = { text: event.detail.data.innerHTML }
    this.container.querySelector(`.${this.CSS.fields.text}`).innerHTML = this.data.text
  }

  // Check for emptiness
  validate(blockData) {
    return blockData.text.trim() !== ''
  }

  // Define the types of paste that should be handled by this tool.
  /*
  static get pasteConfig() {
    return { tags: ['P'] }
  }
  */
}
