import { generateId, make } from '../util'
import EditorTool from './_editor-tool'

export default class ListTool extends EditorTool {
  static get toolbox() {
    return {
      icon: '<i class="list icon"></i>',
      title: 'List',
    }
  }

  // Sanitizer data before saving
  static get sanitize() {
    return {
      items: {},
    }
  }

  constructor({data, _config, api}) {
    super({ // Data
      id: data.id || generateId(),
      items: data.items || [],
      type: ['text', 'contents', 'references'].includes(data.type) ? data.type : 'text',
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
            { name: 'references', icon: 'external square alternate icon' },
          ]
        },
        style: {
          requires: { type: 'text' },
          options: [
            { name: 'unordered', icon: 'list ul' },
            { name: 'ordered', icon: 'list ol' },
            { name: 'leaf', icon: 'leaf' },
          ]
        },
      },
    }, api)

    this.CSS.item = `${this.CSS.container}__item`
  }

  save(toolElement) {
    const itemsData = []
    const items = toolElement.querySelectorAll(`.${this.CSS.item}`)

    for (let i = 0; i < items.length; i++) {
      const value = items[i].innerHTML.replace('<br>', ' ').trim()
      if (value) itemsData.push(items[i].innerHTML)
    }

    this.removeInactiveTunes()
    return Object.assign(this.data, { items: itemsData })
  }

  render() {
    this.container = make('ul', [this.CSS.baseClass, this.CSS.container], { contentEditable: true })
    this.container.addEventListener('keydown', event => this._onItemKeydown(event))

    if (this.data.items.length) {
      this.data.items.forEach(item => {
        make('li', this.CSS.item, { innerHTML: item }, this.container)
      })
    } else {
      make('li', this.CSS.item, {}, this.container)
    }

    // TODO: Extract this into a function in the super class
    for (const key in this.tunes) {
      const group = this.tunes[key]
      for (let i = 0; i < group.options.length; i++) {
        const tune = group.options[i]
        this.container.classList.toggle(this.CSS.tunes[tune.name], this.isTuneActive(tune))
      }
    }

    return this.container
  }

  _onItemKeydown(event) {
    if (event.key == 'Enter' || event.keyCode == 13) { // ENTER
      const item = this.currentItem
      const items = item.parentNode.children
      if (items.length >= 2 && item.nextSibling == null && !item.textContent.trim().length) {
        this.api.blocks.insert()
        this.api.caret.setToNextBlock('start', 0)
        item.remove()
        event.preventDefault()
        event.stopPropagation()
        return false
      }
    } else if (event.key == 'Backspace' || event.keyCode == 8) { // BACKSPACE
      const items = this.container.querySelectorAll(`.${this.CSS.item}`)
      const firstItem = items[0]

      // Save the last one.
      if (items.length < 2 && firstItem && !firstItem.innerHTML.replace('<br>', ' ').trim()) {
        event.preventDefault()
      }
    }

    return true
  }

  // Returns current List item by the caret position
  get currentItem() {
    let currentNode = window.getSelection().anchorNode

    if (currentNode.nodeType !== Node.ELEMENT_NODE) {
      currentNode = currentNode.parentNode
    }

    return currentNode.closest(`.${this.CSS.item}`)
  }

  onPaste(event) {
    const list = event.detail.data
    const { tagName: tag } = list
    let items = []

    if (tag === 'LI') {
      items = [list.innerHTML]
    } else {
      const listItems = Array.from(list.querySelectorAll('LI'))
      items = listItems.map(li => li.innerHTML).filter(item => Boolean(item.trim()))
    }

    this.data = {
      style: tag == 'OL' ? 'ordered' : 'unordered',
      items: items,
    }
  }

  // Select LI content by CMD+A
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

  // Define the types of paste that should be handled by this tool.
  static get pasteConfig() {
    return { tags: ['OL', 'UL', 'LI'] }
  }

  // Allow native enter behaviour
  static get enableLineBreaks() {
    return true
  }
}
