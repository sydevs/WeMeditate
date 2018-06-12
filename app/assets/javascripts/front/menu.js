
var Menu = {
  // These variables will be set on load
  is_front_page: false,
  page_root: null,
  header: null,

  stickyPoint: 88,
  inversePoint: 0,

  load: function() {
    console.log('loading Menu.js')
    Menu.page_root = $('html')
    Menu.header = $('header')
    Menu.header.css('height', 'auto')
    Menu.header.on('click', '.burger-button', Menu.toggle_menu)
    $(window).scroll(Menu._on_scroll)

    $banner = $('main > section:first-child')

    if ($banner.hasClass('format-banner') && $banner.children('background').hasClass('inverse')) {
      Menu.inversePoint = $banner.outerHeight()
    }

    if ($('body').hasClass('application-front')) {
      Menu.stickyPoint = 153
    }

    Menu._on_scroll()
  },

  toggle_menu: function() {
    Menu.page_root.toggleClass('show-menu')
  },

  _on_scroll: function() {
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
  },
}

$(document).on('turbolinks:load', function() { Menu.load() })
