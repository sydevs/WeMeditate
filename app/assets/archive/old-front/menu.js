/** HEADER / MENU
 * This file handles the behaviour of the site-wide header.
 * Notably it controls when the header should become fixed to the top of the page (aka sticky),
 * and when the header should inverse it's colours (if relevant)
 */

const Menu = {
  // These variables will be set on load
  is_front_page: false,
  header: null,
  menu: null,
  scroll: null,

  scrollspy: null,
  scrollspyTop: null,
  scrollspyHeight: null,

  menubarHeight: 0,
  stickyPoint: 0,
  inversePoint: 0,
  scrollOffset: 0,

  load() {
    console.log('loading Menu.js')
    Menu.header = $('header.header')
    Menu.scrollspy = $('#header-scrollspy-progress')
    Menu.header.css('height', 'auto')
    Menu.header.on('click', '.header-menu-item.submenu > a', Menu._on_toggle_submenu)
    Menu.header.on('click', '.burger', Menu.toggle_menu)
    Menu.menubarHeight = $('.header-bar:visible').outerHeight(true)

    $('html').removeClass('noscroll')
    Menu.header.removeClass('show-menu')

    $(window).scroll(Menu._on_scroll)
    $(window).resize(Menu._on_resize)
    Menu._on_resize()
    Menu._on_scroll()

    if (Menu.scroll == null) {
      Menu.scroll = new SmoothScroll('a[href*="#"]', {
        offset: function() {
          return Menu.stickyPoint
        }
      })
    }

    let $scrollspyTarget = $('.scrollspy-target')
    if ($scrollspyTarget.length > 0) {
      Menu.scrollspyTop = $scrollspyTarget.offset().top
      Menu.scrollspyHeight = $scrollspyTarget.height()
    } else {
      Menu.scrollspy.remove()
    }
  },

  toggle_menu() {
    let show = !Menu.header.hasClass('show-menu')
    Menu.header.toggleClass('show-menu', show)
    $('html').toggleClass('noscroll', show)
  },

  _on_toggle_submenu(e) {
    $(this).closest('.submenu').toggleClass('expand')
    e.preventDefault()
  },

  _on_resize() {
    let desktop = Menu.header.find('.header-wrap:visible').hasClass('desktop')
    Menu.stickyPoint = desktop ? Menu.header.outerHeight(true) - Menu.menubarHeight : 0

    let $splash = $('section.format-splash:first-child')
    if ($splash.length > 0 && $splash.children('.splash').hasClass('inverse')) {
      if ($splash.children('.splash').hasClass('style-contact-page')) {
        Menu.inversePoint = Menu.stickyPoint
      } else {
        Menu.inversePoint = $splash.outerHeight() - Menu.menubarHeight
      }
    } else {
      Menu.inversePoint = 0
    }
  },

  _on_scroll() {
    let scrollTop = $(window).scrollTop()

    if (scrollTop > Menu.stickyPoint) {
      if (!Menu.header.hasClass('sticky')) {
        Menu.header.css('height', Menu.header.outerHeight() + 'px')
        Menu.header.addClass('sticky')
      }
    } else {
      Menu.header.css('height', 'auto')
      Menu.header.removeClass('sticky')
    }

    if (Menu.inversePoint > 0) {
      Menu.header.toggleClass('inverse', scrollTop < Menu.inversePoint)
    }

    if (Menu.scrollspyTop != null) {
      let percentage = (Math.max(0, Math.min(1, (scrollTop - Menu.scrollspyTop) / (Menu.scrollspyHeight - screen.height)))) * 100
      Menu.scrollspy.css('width', percentage + '%')
    }
  },
}

$(document).on('turbolinks:load', () => { Menu.load() })
