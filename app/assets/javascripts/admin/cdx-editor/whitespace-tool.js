/* global EditorTool, Util, translate */
/* exported WhitespaceTool */

class WhitespaceTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="minus icon"></i>',
      title: translate.content.blocks.whitespace,
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      text: false,
      url: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || Util.generateId(),
      size: data.size || 'medium',
      decorations: data.decorations || {},
    }, { // Config
      id: 'whitespace',
      decorations: ['triangle', 'gradient', 'circle'],
      fields: {},
      tunes: [
        {
          name: 'small',
          icon: 'compress',
          group: 'size',
        },
        {
          name: 'medium',
          icon: 'expand',
          group: 'size',
        },
        {
          name: 'large',
          icon: 'expand arrows alternate',
          group: 'size',
        },
      ],
    }, api)
  }

  render() {
    this.container = super.render()
    Util.make('span', null, { innerText: translate.content.blocks.whitespace }, this.container)

    return this.container
  }

  static get contentless() {
    return true
  }
}
