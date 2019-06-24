
class Header {

  constructor(element) {
    this.container = element
    this.scrollspy = document.getElementById('scrollspy-progress')
    this.container.style.height = 'auto'
    this.navigationHeight = $('.header__navigation', element).outerHeight(true)

    this.desktopWrapper = element.querySelector('.header__wrapper--desktop')

    element.querySelector('.header__navigation__burger').addEventListener('click', _event => this.toggleMenu())
    $(element).on('click', '.header__menu__item--submenu > a', event => {
      this.toggleSubmenu(event.target)
      event.preventDefault()
    })

    document.body.classList.remove('noscroll')
    this.container.classList.remove('header--show-menu')

    window.addEventListener('resize', _event => this._onResize())
    window.addEventListener('scroll', _event => this._onScroll())
    this._onResize()
    this._onScroll()

    let $scrollspyTarget = $('.scrollspy-target')
    if ($scrollspyTarget.length > 0) {
      this.scrollspyTop = $scrollspyTarget.offset().top
      this.scrollspyHeight = $scrollspyTarget.height()
      this.scrollspy.style.display = null
    } else {
      this.scrollspy.style.display = 'none'
    }
  }

  toggleMenu() {
    let show = !this.container.classList.contains('header--show-menu')
    this.container.classList.toggle('header--show-menu', show)
    document.body.classList.toggle('noscroll', show)
  }

  toggleSubmenu(element) {
    element.closest('.header__menu__item--submenu').classList.toggle('header__menu__item--expand')
  }

  scrollTo(element, offset = 60, speed = 3000) {
    const bodyRect = document.body.getBoundingClientRect()
    const elementRect = element.getBoundingClientRect()
    const target = elementRect.top - bodyRect.top - offset
    console.log('scroll to', target)
    this.scroll.animateScroll(target, speed, { speed: speed, updateURL: false })
  }

  _onResize() {
    const isDesktop = $(this.desktopWrapper).is(':visible')
    this.headerHeight = $(this.container).outerHeight(true)
    this.stickyPoint = isDesktop ? this.headerHeight - this.navigationHeight : 0
    if (typeof zenscroll !== 'undefined') zenscroll.setup(null, this.headerHeight)

    let $splash = $('.content__splash')
    if ($splash.length > 0 && $splash.hasClass('content__splash--invert')) {
      this.inversionPoint = $splash.outerHeight() - this.navigationHeight
    } else {
      this.inversionPoint = 0
    }
  }

  _onScroll() {
    let scrollTop = $(window).scrollTop()

    if (scrollTop > this.stickyPoint) {
      // Enable sticky-ing
      if (!this.container.classList.contains('header--sticky')) {
        this.container.style.height = `${$(this.container).outerHeight()}px`
        this.container.classList.add('header--sticky')
      }
    } else {
      this.container.style.height = 'auto'
      this.container.classList.remove('header--sticky')
    }

    if (this.inversionPoint > 0) {
      this.container.classList.toggle('header--invert', scrollTop < this.inversionPoint)
    }

    if (this.scrollspyTop != null) {
      let percentage = (Math.max(0, Math.min(1, (scrollTop - this.scrollspyTop) / (this.scrollspyHeight - screen.height)))) * 100
      this.scrollspy.style.width = `${percentage}%`
    }
  }
}
