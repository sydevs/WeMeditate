/* global EditorTool, Util, translate */
/* exported FormTool */

class FormTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="tasks icon"></i>',
      title: translate.content.blocks.form,
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      title: false,
      subtitle: false,
      text: false,
      action: false,
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || Util.generateId(),
      title: data.title || '',
      subtitle: data.subtitle || '',
      text: data.text || '',
      action: data.action || '',
      format: ['signup', 'contact'].includes(data.format) ? data.format : 'signup',
    }, { // Config
      id: 'form',
      fields: {
        title: { label: 'Title', input: 'title', contained: true },
        subtitle: { label: 'Subtitle', contained: true },
        text: { label: 'Text', contained: true },
        action: { label: 'Button Text', input: 'button', contained: true },
      },
      tunes: [
        {
          name: 'signup',
          label: 'Sign Up Form',
          icon: 'paper plane',
          group: 'format',
        },
        {
          name: 'contact',
          label: 'Contact Form',
          icon: 'envelope',
          group: 'format',
        },
      ],
    }, api)

    this.CSS.placeholder = `${this.CSS.container}__placeholder`
    this.CSS.fields_placeholder = `${this.CSS.container}__fields_placeholder`
    this.CSS.placeholders = {
      email: `${this.CSS.placeholder}--email`,
      message: `${this.CSS.placeholder}--message`,
    }
  }

  render() {
    const container = super.render()
    const button = container.querySelector(`.${this.CSS.fields.action}`)
    const fields = Util.make('div', this.CSS.fields_placeholder)

    Util.make('div', [this.CSS.placeholder, this.CSS.placeholders.email], { innerText: translate.email }, fields)
    Util.make('div', [this.CSS.placeholder, this.CSS.placeholders.message], { innerText: translate.message }, fields)

    container.insertBefore(fields, button)
    return container
  }

  static get enableLineBreaks() {
    return false
  }

  // Empty Structured is not empty Block
  static get contentless() {
    return false
  }
}
