/* global $, Application, zenscroll */
/* exported Categories */

class Categories {

  constructor(element) {
    this.container = element
    this.header = Application.element.header
    this.filters = element.querySelector('.inspiration__filters')

    window.addEventListener('resize', _event => this._onResize())
    window.addEventListener('scroll', _event => this._onScroll())

    if (typeof zenscroll !== 'undefined') {
      this._onResize()
      this._onScroll()
    }
  }

  init() {
    this._onResize()
    this._onScroll()
  }

  _onResize() {
    this.topOffset = $(this.filters).offset().top
  }

  _onScroll() {
    let scrollTop = $(window).scrollTop()

    let stickyPt = this.topOffset - this.header.navigationHeight - 29

    if (scrollTop > stickyPt) {
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