/* global EditorTool, Util, translate */
/* exported ActionTool */

class ActionTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="hand point up icon"></i>',
      title: translate.content.blocks.action,
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
      text: data.text || '',
      url: data.url || '',
      decorations: data.decorations || {},
    }, { // Config
      id: 'action',
      decorations: ['leaves'],
      fields: {
        text: { input: 'button', contained: true },
        url: { input: 'url', contained: true },
      },
      tunes: [],
    }, api)
  }

  static get enableLineBreaks() {
    return true
  }

  static get contentless() {
    return false
  }
}
