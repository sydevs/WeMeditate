
class HeaderTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="heading icon"></i>',
      title: 'Header',
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      text: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      text: data.text || '',
      centered: data.centered || false,
    }, { // Config
      id: 'header',
      fields: {
        text: { label: '', input: 'title' },
      },
      tunes: [
        {
          name: 'centered',
          label: 'Centered',
          icon: 'align center',
        }
      ],
    }, api)
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
    return { tags: ['H1', 'H2', 'H3', 'H4', 'H5', 'H6'] }
  }
}
