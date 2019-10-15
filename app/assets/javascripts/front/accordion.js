/** Accordion
 * Allows an accordion block to be opened and closed.
 */

class Accordion {

  constructor(element) {
    this.container = element
    this.activeItem = null

    const textElements = element.querySelectorAll('.content__structured__text')
    for (let index = 0; index < textElements.length; index++) {
      textElements[index].style.maxHeight = textElements[index].offsetHeight + 'px'
    }

    const titleElements = element.querySelectorAll('.content__structured__title')
    for (let index = 0; index < titleElements.length; index++) {
      titleElements[index].addEventListener('click', event => this.selectItem(event.currentTarget.parentNode))
      titleElements[index].parentNode.classList.add('content__structured__item--closed')
    }
  }

  unload() {
    const textElements = this.container.querySelectorAll('.content__structured__text')
    for (let index = 0; index < textElements.length; index++) {
      textElements[index].parentNode.classList.remove('content__structured__item--closed')
      textElements[index].style.maxHeight = null
    }

    this.activeItem = null
  }

  selectItem(item) {
    if (this.activeItem) this.activeItem.classList.add('content__structured__item--closed')
    if (this.activeItem != item) {
      this.activeItem = item
      this.activeItem.classList.remove('content__structured__item--closed')
    } else {
      this.activeItem = null
    }
  }

}
