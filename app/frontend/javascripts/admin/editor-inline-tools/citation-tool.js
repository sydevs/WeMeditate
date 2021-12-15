import SelectionUtils from '../selection'
import { make } from '../util'

const ENTER_KEY = 13

export default class CitationTool {
  static get isInline() {
    return true
  }

  static get title() {
    return 'Citation'
  }

  get shortcut() {
    return 'CMD+P'
  }

  get state() {
    return this._state
  }

  set state(state) {
    this._state = state
    this.button.classList.toggle(this.api.styles.inlineToolButtonActive, state)
  }

  static get sanitize() {
    return {
      cite: {
        'data-title': true,
        'data-link': true
      }
    }
  }

  constructor({ api }) {
    this.api = api
    this.button = null
    this.selection = new SelectionUtils()
    this._state = false

    this.tag = 'CITE'
    this.class = 'cdx-citation'
  }

  render() {
    this.button = document.createElement('button')
    this.button.type = 'button'
    this.button.innerHTML = '<i class="fitted share icon" /></svg>'
    this.button.classList.add(this.api.styles.inlineToolButton)

    return this.button
  }

  surround(range) {
    this.cite = this.api.selection.findParentTag(this.tag)

    if (this.actions.hidden) {
      this.selection.save()
      //this.selection.setFakeBackground()
    } else {
      this.selection.restore()
      //this.selection.removeFakeBackground()
    }
    
    if (this.state) {
      this.unwrap(range)
    } else {
      this.wrap(range)
    }
  } 

  wrap(range) {
    const selectedText = range.extractContents().textContent
    const cite = document.createElement(this.tag)
    this.cite = cite
    cite.classList.add(this.class)
    cite.innerText = selectedText
    range.insertNode(cite)
    this.api.selection.expandToTag(cite)
  }

  unwrap(range) {
    const text = this.cite.firstChild

    this.cite.remove()
    range.insertNode(text)
  }

  checkState() {
    const cite = this.api.selection.findParentTag(this.tag)
    this.state = Boolean(cite)

    if (this.state) {
      this.showActions(cite)
    } else {
      this.hideActions()
    }
  }

  renderActions() {
    this.actions = make('div')

    this.inputTitle = make('input', '', {
      placeholder: 'Set citation title'
    }, this.actions)

    this.inputLink = make('input', '', {
      placeholder: 'Set citation link'
    }, this.actions)

    return this.actions
  }

  showActions(cite) {
    this.inputTitle.value = cite.dataset.title || ''
    this.inputLink.value = cite.dataset.link || ''

    this.inputTitle.addEventListener('keydown', event => this.enterPressed(event))
    this.inputLink.addEventListener('keydown', event => this.enterPressed(event))

    this.inputTitle.focus()
    this.actions.hidden = false
  }

  hideActions() {
    this.actions.hidden = true
  }

  clear() {
    this.hideActions()
  }

  enterPressed(event) {
    if (event.keyCode !== ENTER_KEY) return

    let title = this.inputTitle.value || ''
    let link = this.inputLink.value || ''

    if (!title.trim() || !link.trim()) {
      this.selection.restore()
      this.selection.removeFakeBackground()
      this.unwrap(SelectionUtils.range)
      event.preventDefault()
      this.hideActions()
      return
    }

    if (!this.validateURL(link)) {
      this.notifier.show({
        message: 'Pasted link is not valid.',
        style: 'error',
      })

      console.warn('Incorrect Link pasted', link)
      return
    }

    this.selection.restore()
    this.selection.removeFakeBackground()
    this.setData(title, link)

    // Preventing events that will be able to happen
    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()
    this.selection.collapseToEnd()
    this.api.inlineToolbar.close()
  }

  setData(title, link) {
    const cite = this.cite // this.api.selection.findParentTag(this.tag)
    if (cite) {
      this.api.selection.expandToTag(cite)
    }

    link = this.prepareLink(link)
    this.inputLink.value = link
    cite.dataset.link = link
    cite.dataset.title = this.inputTitle.value
  }

  // HELPERS

  validateURL(str) {
    return !/\s/.test(str)
  }

  prepareLink(link) {
    link = link.trim()
    link = this.addProtocol(link)
    return link
  }

  addProtocol(link) {
    if (/^(\w+):(\/\/)?/.test(link)) {
      return link
    }

    const isInternal = /^\/[^/\s]/.test(link)
    const isAnchor = link.substring(0, 1) === '#'
    const isProtocolRelative = /^\/\/[^/\s]/.test(link)

    if (!isInternal && !isAnchor && !isProtocolRelative) {
      link = 'http://' + link
    }

    return link
  }
  
}