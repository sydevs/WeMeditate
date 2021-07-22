/* global EditorTool, Util */
/* exported ParagraphTool */

class ParagraphTool extends EditorTool {

  // Sanitizer data before saving
  static get sanitize() {
    return {
      text: {},
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || Util.generateId(),
      text: data.text || '',
    }, { // Config
      id: 'paragraph',
      fields: {
        text: { label: '', contained: false },
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
  static get pasteConfig() {
    return { tags: ['P'] }
  }

  // Enable Conversion Toolbar. Paragraph can be converted to/from other tools
  /*
  static get conversionConfig() {
    return {
      export: 'text', // to convert Paragraph to other block, use 'text' property of saved data
      import: 'text', // to convert other block's exported string to Paragraph, fill 'text' property of tool data
    }
  }
  */
  
}
