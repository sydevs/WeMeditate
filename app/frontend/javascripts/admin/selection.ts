/**
 * NOTE: SelectionUtils was mainly taken from EditorJS, due to the fact that it
 * is required to properly create a custom LinkInlineTool. EditorJs does not
 * expose all required methods, so we had to copy it.
 * ==> Issue: https://github.com/codex-team/editor.js/issues/1066
 *
 * @see https://github.com/codex-team/editor.js/blob/737ba2abb423665257cf6ccc5e8472742433322f/src/components/selection.ts
 */

/**
 * Working with selection
 * @typedef {SelectionUtils} SelectionUtils
 */
export default class SelectionUtils {
  public instance: Selection = null

  public selection: Selection = null

  /**
   * This property can store SelectionUtils's range for restoring later
   * @type {Range|null}
   */
  public savedSelectionRange: Range = null

  /**
   * Fake background is active
   *
   * @return {boolean}
   */
  public isFakeBackgroundEnabled = false

  /**
   * Native Document's commands for fake background
   */
  private readonly commandBackground: string = 'backColor'

  private readonly commandRemoveFormat: string = 'removeFormat'

  /**
   * Return first range
   * @return {Range|null}
   */
  static get range(): Range {
    const selection = window.getSelection()

    return selection && selection.rangeCount ? selection.getRangeAt(0) : null
  }

  /**
   * Returns selected text as String
   * @returns {string}
   */
  static get text(): string {
    return window.getSelection ? window.getSelection().toString() : ''
  }

  /**
   * Returns window SelectionUtils
   * {@link https://developer.mozilla.org/ru/docs/Web/API/Window/getSelection}
   * @return {Selection}
   */
  public static get(): Selection {
    return window.getSelection()
  }

  /**
   * Removes fake background
   */
  public removeFakeBackground() {
    if (!this.isFakeBackgroundEnabled) {
      return
    }

    this.isFakeBackgroundEnabled = false
    document.execCommand(this.commandRemoveFormat)
  }

  /**
   * Sets fake background
   */
  public setFakeBackground() {
    document.execCommand(this.commandBackground, false, '#a8d6ff')
    this.isFakeBackgroundEnabled = true
  }

  /**
   * Save SelectionUtils's range
   */
  public save(): void {
    this.savedSelectionRange = SelectionUtils.range
    console.log('save range', this.savedSelectionRange.toString())
  }

  /**
   * Restore saved SelectionUtils's range
   */
  public restore(): void {
    if (!this.savedSelectionRange) {
      return
    }

    console.log('restore range', this.savedSelectionRange.toString())
    const sel = window.getSelection()

    sel.removeAllRanges()
    sel.addRange(this.savedSelectionRange)
    console.log('restored range', SelectionUtils.range.toString())
  }

  /**
   * Clears saved selection
   */
  public clearSaved(): void {
    this.savedSelectionRange = null
  }

  /**
   * Collapse current selection
   */
  public collapseToEnd(): void {
    const sel = window.getSelection()
    const range = document.createRange()

    range.selectNodeContents(sel.focusNode)
    range.collapse(false)
    sel.removeAllRanges()
    sel.addRange(range)
  }
}