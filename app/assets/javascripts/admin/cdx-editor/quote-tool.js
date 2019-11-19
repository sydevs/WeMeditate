/* global EditorTool, Util, translate */
/* exported QuoteTool */

class QuoteTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="quote left icon"></i>',
      title: translate.content.blocks.quote,
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      text: { br: true },
      credit: false,
      caption: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || Util.generateId(),
      text: data.text || '',
      credit: data.credit || '',
      caption: data.caption || '',
      asPoem: data.asPoem || false,
      position: ['left', 'right', 'center'].includes(data.position) ? data.position : 'center',
    }, { // Config
      id: 'quote',
      fields: {
        text: { label: translate.content.placeholders.quote, input: 'textarea', contained: true },
        credit: { input: 'caption', contained: true, optional: true },
        caption: { input: 'caption', contained: true, optional: true },
      },
      tunes: [
        {
          name: 'left',
          icon: 'indent',
          group: 'position',
        },
        {
          name: 'right',
          icon: 'horizontally flipped indent',
          group: 'position',
        },
        {
          name: 'center',
          icon: 'align center',
          group: 'position',
        },
        {
          name: 'asPoem',
          icon: 'quora',
        },
      ],
    }, api)
  }

  render() {
    const container = super.render()
    container.querySelector(`.${this.CSS.fields.text}`).addEventListener('keydown', event => this.insertParagraphBreak(event))
    return container
  }

  /*selectTune(tune) {
    let active = super.selectTune(tune)

    if (tune.name == 'asPoem') {
      this.setTuneValue('position', active ? null : 'centered')
    } else {
      this.setTuneBoolean('asPoem', false)
    }
  }*/

  static get enableLineBreaks() {
    return true
  }

  // Empty tool is not empty Block
  static get contentless() {
    return false
  }
}
