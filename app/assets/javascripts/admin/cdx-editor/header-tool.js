/* global EditorTool, Util, translate */
/* exported HeaderTool */

class HeaderTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="heading icon"></i>',
      title: translate.content.blocks.header,
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
      id: data.id || Util.generateId(),
      text: data.text || '',
      centered: data.centered || false,
    }, { // Config
      id: 'header',
      decorations: false,
      fields: {
        text: { label: '', input: 'title' },
      },
      tunes: [
        {
          name: 'centered',
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
    this.data = { text: event.detail.data.innerText }
  }

  // Check for emptiness
  validate(blockData) {
    return blockData.text.trim() !== ''
  }

  // Define the types of paste that should be handled by this tool.
  static get pasteConfig() {
    return { tags: ['H1', 'H2', 'H3', 'H4', 'H5', 'H6'] }
  }
  
  // Enable Conversion Toolbar. Header can be converted to/from other tools
  static get conversionConfig() {
    return {
      export: 'text', // use 'text' property for other blocks
      import: 'text', // fill 'text' property from other block's export string
    }
  }
}
