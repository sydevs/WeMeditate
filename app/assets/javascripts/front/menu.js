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
  chapters: null,
  chapter_items: null,
  chapter_offsets: null,

  scroll: null,

  menubarHeight: 0,
  chaptersStickyPoint: 0,
  stickyPoint: 0,
  inversePoint: 0,
  scrollOffset: 0,

  load() {
    console.log('loading Menu.js')
    Menu.header = $('header.header')
    Menu.chapters = $('.chapters')
    Menu.chapter_items = Menu.chapters.find('.chapters-item')
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

    let $banner = $('section.format-banner:first-child')
    if ($banner.length > 0 && $banner.children('.banner').hasClass('inverse')) {
      if ($banner.children('.banner').hasClass('style-contact-page')) {
        Menu.inversePoint = Menu.stickyPoint
      } else {
        Menu.inversePoint = $banner.outerHeight() - Menu.menubarHeight
      }
    } else {
      Menu.inversePoint = 0
    }

    if (Menu.chapters.length > 0) {
      Menu.chaptersStickyPoint = Menu.chapters.offset().top
      let offset_adjustment = Menu.stickyPoint

      Menu.chapter_offsets = []
      Menu.chapter_items.each(function() {
        let id = $(this).attr('href')
        let $target = $(id)
        Menu.chapter_offsets.push($target.offset().top - offset_adjustment)
      })

      $last_section = $('article > section:last-child')
      Menu.chapter_offsets.push($last_section.offset().top + $last_section.outerHeight(true) - offset_adjustment)
    }
  },

  _on_scroll() {
    let scrollTop = $(window).scrollTop()

    //console.log('top', scrollTop, 'sticky', Menu.stickyPoint, 'menubar', Menu.menubarHeight)

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

    if (Menu.chaptersStickyPoint > 0) {
      let $headerWrap = Menu.header.find('.header-wrap:visible').first()
      let headerHeight = $headerWrap.children('.header-bar').outerHeight()

      let $chaptersContainer = Menu.chapters.children('.chapters-wrapper')
      let chaptersHeight = $chaptersContainer.outerHeight()

      //console.log(scrollTop, '>', Menu.chaptersStickyPoint, '-', headerHeight, '=', scrollTop > Menu.chaptersStickyPoint - headerHeight)

      if (scrollTop < Menu.chaptersStickyPoint - headerHeight) {
        Menu.chapters.css('height', 'auto')
        $chaptersContainer.css('top', 'auto')
        Menu.chapters.removeClass('sticky')
      } else if (!Menu.chapters.hasClass('sticky')) {
        Menu.chapters.css('height', chaptersHeight + 'px')
        $chaptersContainer.css('top', headerHeight + 'px')
        Menu.chapters.addClass('sticky')
      }
    }

    Menu.chapter_items.each(function(index) {
      let $item = $(this)
      let targetTop = Menu.chapter_offsets[index]
      let targetBottom = Menu.chapter_offsets[index+1]
      let $progress = $item.children('.chapters-item-progress')

      if (scrollTop < targetBottom) {
        let percentage = (Math.max(0, Math.min(1, (scrollTop - targetTop) / (targetBottom - targetTop)))) * 100
        $progress.css('width', percentage + '%')
      } else {
        $progress.css('width', '100%')
      }

      $item.toggleClass('active', (targetTop < scrollTop && scrollTop < targetBottom))
    })
  },
}

$(document).on('turbolinks:load', () => { Menu.load() })
