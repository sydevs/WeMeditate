import { generateId, make } from '../util'
import { translate } from '../../i18n'
import EditorTool from './_editor-tool'

export default class ListTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="list icon"></i>',
      title: translate('blocks.list.label'),
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || generateId(),
      items: data.items || [],
      type: ['text', 'contents'].includes(data.type) ? data.type : 'text',
      style: ['unordered', 'ordered', 'leaf'].includes(data.style) ? data.style : 'unordered',
    }, { // Config
      id: 'list',
      fields: {
        items: { input: false }
      },
      tunes: {
        type: {
          options: [
            { name: 'text', icon: 'font', },
            { name: 'contents', icon: 'book' },
          ]
        },
        style: {
          requires: { type: ['text'] },
          options: [
            { name: 'unordered', icon: 'list ul' },
            { name: 'ordered', icon: 'list ol' },
            { name: 'leaf', icon: 'leaf' },
          ]
        },
      },
    }, api)

    this.CSS.item = `${this.CSS.container}__item`
    this.CSS.refresh = `${this.CSS.container}__refresh`
  }

  save(toolElement) {
    const itemsData = []
    const items = toolElement.querySelectorAll(`.${this.CSS.item}`)

    for (let i = 0; i < items.length; i++) {
      const value = items[i].innerHTML.replace('<br>', ' ').trim()
      let item = { text: items[i].innerHTML }
      if (this.data.type == 'contents') item.level = this.data.items[i].level
      if (value) itemsData.push(item)
    }

    this.removeInactiveData()
    return Object.assign(this.data, { items: itemsData })
  }

  refreshTableOfContents() {
    const blocksCount = this.api.blocks.getBlocksCount()
    this.data.items = []
    for (let i = 0; i < blocksCount; i++) {
      const block = this.api.blocks.getBlockByIndex(i)
      if (block.name == 'paragraph') {
        const element = block.holder
        if (element.dataset.type == 'header') {
          const text = element.querySelector('.cdx-input[data-key=text]').textContent
          this.data.items.push({ text: text, level: element.dataset.level })
        }
      } else {
        //console.log('skip block', block.name)
      }
    }

    this.renderItems()
  }

  render() {
    this.container = make('div', [this.CSS.baseClass, this.CSS.container], {
      data: { contents: translate('blocks.list.type.contents') }
    })
    this.container.addEventListener('keydown', event => this._onItemKeydown(event))

    const editable = this.data.type != 'contents'
    this.listElement = make('ul', [this.CSS.input], { contentEditable: editable, data: { key: 'items' } }, this.container)

    if (this.data.items.length) {
      this.renderItems()
    } else {
      make('li', this.CSS.item, {}, this.listElement)
    }

    this.refreshButton = make('div', [this.CSS.refresh], {}, this.container)
    make('i', ['fitted', 'sync', 'alternate', 'icon'], {}, this.refreshButton)
    this.refreshButton.addEventListener('click', () => this.refreshTableOfContents())
    this.container.addEventListener('click', () => {
      if (this.data.type == 'contents') {
        this.refreshTableOfContents() 
      }
    })

    return this.container
  }

  renderItems() {
    this.listElement.innerHTML = null
    this.data.items.forEach(item => {
      if (typeof(item) == 'object') {
        make('li', this.CSS.item, { innerHTML: item.text, data: { level: item.level } }, this.listElement)
      } else {
        make('li', this.CSS.item, { innerHTML: item }, this.listElement)
      }
    })
  }

  selectTune(tune) {
    super.selectTune(tune)

    if (this.data.type == 'contents') {
      this.listElement.contentEditable = false
      console.log('refresh', this.data)
      this.refreshTableOfContents()
    } else {
      this.listElement.contentEditable = true
    }
  }

  _onItemKeydown(event) {
    const [ENTER, BACKSPACE] = [13, 8] // key codes

    switch (event.keyCode) {
    case ENTER:
      this.getOutofList(event)
      break
    case BACKSPACE:
      this.backspace(event)
      break
    }
  }

  /**
   * Returns current List item by the caret position
   */
  get currentItem() {
    let currentNode = window.getSelection().anchorNode

    if (currentNode.nodeType !== Node.ELEMENT_NODE) {
      currentNode = currentNode.parentNode
    }

    return currentNode.closest(`.${this.CSS.item}`)
  }

  /**
   * Get out from List Tool by Enter on the empty last item
   */
  getOutofList(event) {
    const items = this.container.querySelectorAll('.' + this.CSS.item)

    // Save the last one.
    if (items.length < 2) {
      return
    }

    const lastItem = items[items.length - 1]
    const currentItem = this.currentItem

    // Prevent Default li generation if item is empty
    if (currentItem === lastItem && !lastItem.textContent.trim().length) {
      // Insert New Block and set caret
      currentItem.parentElement.removeChild(currentItem)
      this.api.blocks.insert()
      this.api.caret.setToBlock(this.api.blocks.getCurrentBlockIndex())
      event.preventDefault()
      event.stopPropagation()
    }
  }

  /**
   * Handle backspace
   */
  backspace(event) {
    const items = this.container.querySelectorAll('.' + this.CSS.item)
    const firstItem = items[0]

    if (!firstItem) {
      return
    }

    // Save the last one.
    if (items.length < 2 && !firstItem.innerHTML.replace('<br>', ' ').trim()) {
      event.preventDefault()
    }
  }

  /**
   * Select LI content by CMD+A
   */
  selectItem(event) {
    event.preventDefault()

    const selection = window.getSelection()
    const currentNode = selection.anchorNode.parentNode
    const currentItem = currentNode.closest('.' + this.CSS.item)
    const range = new Range()

    range.selectNodeContents(currentItem)

    selection.removeAllRanges()
    selection.addRange(range)
  }

  /**
   * Handle UL, OL and LI tags paste and returns List data
   */
  pasteHandler(event) {
    const element = event.detail.data
    const { tagName: tag } = element
    let style

    switch (tag) {
    case 'OL':
      style = 'ordered'
      break
    case 'UL':
    case 'LI':
      style = 'unordered'
    }

    const data = {
      type: 'text',
      style: style,
      items: []
    }

    if (tag === 'LI') {
      data.items = [element.innerHTML]
    } else {
      data.items = Array
        .from(element.querySelectorAll('LI'))
        .map(li => li.innerHTML)
        .filter(item => Boolean(item.trim()))
    }

    this.data = data

    this.container.innerHTML = ''
    const list = make('ul', [this.CSS.input], { contentEditable: true, data: { key: 'items' } }, this.container)
    this.data.items.forEach(item => {
      make('li', this.CSS.item, { innerHTML: item }, list)
    })
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      items: {},
    }
  }

  // Define the types of paste that should be handled by this tool.
  static get pasteConfig() {
    return { tags: ['OL', 'UL', 'LI'] }
  }

  // Allow native enter behaviour
  static get enableLineBreaks() {
    return true
  }
}
