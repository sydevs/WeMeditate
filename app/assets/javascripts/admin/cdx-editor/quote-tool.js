
class QuoteTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="quote left icon"></i>',
      title: translate['content']['blocks']['quote'],
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      text: false,
      credit: false,
      caption: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || generateId(),
      text: data.text || '',
      credit: data.credit || '',
      caption: data.caption || '',
      callout: ['left', 'right'].includes(data.callout) ? data.callout : 'none',
    }, { // Config
      id: 'quote',
      fields: {
        text: { label: translate['content']['placeholders']['quote'], input: 'textarea', contained: true },
        credit: { input: 'caption', contained: true, optional: true },
        caption: { input: 'caption', contained: true, optional: true },
      },
      tunes: [
        {
          name: 'left',
          icon: 'indent',
          group: 'callout',
        },
        {
          name: 'none',
          icon: 'align center',
          group: 'callout',
        },
        {
          name: 'right',
          icon: 'horizontally flipped indent',
          group: 'callout',
        },
      ],
    }, api)
  }

  selectTune(tune) {
    if (this.isTuneActive(tune)) {
      this.setTuneValue(tune.group, '')
    } else {
      super.selectTune(tune)
    }
  }

  static get enableLineBreaks() {
    return true
  }

  // Empty tool is not empty Block
  static get contentless() {
    return false;
  }
}
