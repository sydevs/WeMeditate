
class LinkTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="hand point up icon"></i>',
      title: translate['content']['blocks']['link'],
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      action: false,
      url: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      action: data.action || '',
      url: data.url || '',
      decorations: data.decorations || {},
    }, { // Config
      id: 'link',
      decorations: ['leaves'],
      fields: {
        action: { input: 'button', contained: true },
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
