
class ParagraphTool extends EditorTool {

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
    }, { // Config
      id: 'paragraph',
      fields: {
        text: { label: '' },
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
    this.data = { text: event.detail.data }
  }

  // Check for emptiness
  validate(blockData) {
    return blockData.text.trim() !== '';
  }

  // Define the types of paste that should be handled by this tool.
  static get pasteConfig() {
    return { tags: ['P'] }
  }
}
