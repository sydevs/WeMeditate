import { generateId, make } from '../../util'
import { translate } from '../../../i18n'
import EditorTool from '../_editor-tool'

export default class LegacyVimeoTool extends EditorTool {
  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || generateId(),
      items: data.items || [],
    }, { // Config
      id: 'vimeo',
      fields: {},
      tunes: {},
    }, api)

    this.CSS.item = {
      container: `${this.CSS.container}__item`,
      image: `${this.CSS.container}__items__image`,
      title: `${this.CSS.container}__items__title`,
    }
  }

  render() {
    console.log('test0')
    this.container = super.render()
    console.log('test1')
    this.data.items.forEach(item => {
      console.log('test1a')
      this.container.appendChild(this.renderItem(item))
    })

    console.log('test2')
    return this.container
  }

  renderSettings(container) {
    const settingsContainer = make('div', [this.CSS.optionsWrapper], {}, container)

    make('div', this.CSS.optionsHeader, { innerText: 'Vimeo (Legacy)' }, settingsContainer)
    make('p', '', {
      innerText: 'This block is outdated and is no longer editable. Please create a new media block, using videos from JWPlayer instead of Vimeo.'
    }, settingsContainer)

    return settingsContainer
  }

  renderItem(item = {}) {
    const container = make('div', this.CSS.item.container, {})
    const img = make('div', [this.CSS.item.image, 'ui', 'rounded', 'image'], {}, container)
    make('img', null, { src: item.thumbnail }, img)
    make('strong', [this.CSS.item.title], { innerText: item.title }, container)
    return container
  }

  save(_toolElement) {
    return this.data
  }

  validate(blockData) {
    return blockData.items.length > 0
  }

  static get sanitize() {
    return {}
  }

  static get contentless() {
    return false
  }
}
