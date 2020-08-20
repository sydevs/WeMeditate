/* global $, Application */
/* exported Categories */

class Categories {

  constructor(element) {
    this.container = element
    this.header = Application.element.header
    this.filters = element.querySelector('.inspiration__filters')

    window.addEventListener('resize', _event => this._onResize())
    window.addEventListener('scroll', _event => this._onScroll())
  }

  init() {
    this._onResize()
    this._onScroll()
  }

  _onResize() {
    this.topOffset = $(this.filters).offset().top
    // console.log("topOffset: ", this.topOffset)
  }

  _onScroll() {
    let scrollTop = $(window).scrollTop()
    // console.log("F.scrtop: ", scrollTop)

    let stickyPt = this.topOffset - this.header.navigationHeight
    // console.log("F.stkpt: ", stickyPt)

    if (scrollTop > stickyPt) {
      if (!this.container.classList.contains('filters--sticky')) {
        this.container.style.height = `${$(this.container).outerHeight()}px`
        // this.filters.style.top = `${this.header.navigationHeight}px`
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