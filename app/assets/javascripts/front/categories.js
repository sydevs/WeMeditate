/* global $, Application, zenscroll */
/* exported Categories */

class Categories {

  constructor(element) {
    this.container = element
    this.header = Application.element.header
    this.filters = element.querySelector('.inspiration__filters')

    window.addEventListener('scroll', _event => this._onScroll())

    if (typeof zenscroll !== 'undefined') {
      this._onScroll()
    }
  }

  init() {
    this._onScroll()
  }

  _onScroll() {
    let scrollTop = $(window).scrollTop()

    if (scrollTop > this.header.stickyPoint) {
      if (!this.container.classList.contains('filters--sticky')) {
        this.container.style.height = `${$(this.container).outerHeight()}px`
        this.container.classList.add('filters--sticky')
      }
      this.filters.style.top = `${this.header.navigationHeight}px`
    } else {
      this.container.style.height = 'auto'
      this.filters.style.top = '0'
      this.container.classList.remove('filters--sticky')
    }
  }
}