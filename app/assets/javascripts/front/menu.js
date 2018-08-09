
var Menu = {
  // These variables will be set on load
  is_front_page: false,
  page_root: null,
  header: null,
  chapters: null,
  chapter_items: null,
  chapter_offsets: null,

  menubarHeight: 0,
  chaptersStickyPoint: 0,
  stickyPoint: 0,
  inversePoint: 0,

  load: function() {
    console.log('loading Menu.js')
    Menu.page_root = $('html')
    Menu.header = $('header')
    Menu.chapters = $('.chapters')
    Menu.submenu = $('.menu .item .container')
    Menu.chapter_items = Menu.chapters.find('.item')
    Menu.header.css('height', 'auto')
    Menu.header.on('click', '.burger-button', Menu.toggle_menu)
    Menu.header.on('click', '.menu .button ', Menu.toggle_menu_item)
    Menu.menubarHeight = Menu.header.find('.menubar').outerHeight(true)

    Menu.page_root.removeClass('show-menu')

    $(window).scroll(Menu._on_scroll)
    $(window).resize(Menu._on_resize)
    Menu._on_resize()

    //zenscroll.setup(null, Menu.menubarHeight + Menu.chapters.outerHeight() + 10)
    Menu._on_scroll()
  },

  toggle_menu: function() {
    Menu.page_root.toggleClass('show-menu')
    Menu.submenu.each(function () {
      $(this).closest('.item').addClass('item-list')
    })
  },

  toggle_menu_item: function(e) {
    if (Menu.page_root.hasClass('show-menu') && $(this).closest('.item').hasClass('item-list')){
      e.preventDefault()
      $(this).closest('.item').toggleClass('show-content')
    }

  },

  _on_resize: function() {
    Menu.stickyPoint = Menu.header.outerHeight(true) - Menu.menubarHeight

    $banner = $('section.format-banner:first-child')
    if ($banner.length > 0 && $banner.children('.content').hasClass('inverse')) {
      if ($banner.children('.content').hasClass('style-contact-page')) {
        Menu.inversePoint = Menu.stickyPoint
      } else {
        Menu.inversePoint = $banner.outerHeight() - Menu.menubarHeight
      }
    } else {
      Menu.inversePoint = 0
    }

    if (Menu.chapters.length > 0) {
      Menu.chaptersStickyPoint = Menu.chapters.offset().top
      let offset_adjustment = Menu.stickyPoint + 120

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

  _on_scroll: function() {
    let scrollTop = $(window).scrollTop()
    let $headerContainer = Menu.header.find('.container:visible')
    let headerHeight = $headerContainer.hasClass('desktop') ? $headerContainer.find('.menubar').outerHeight() : $headerContainer.outerHeight()

    if (scrollTop > Menu.stickyPoint - headerHeight) {
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
      let $chaptersContainer = Menu.chapters.find('.container')
      let chaptersHeight = $chaptersContainer.outerHeight()
      // console.log('$chaptersContainer', $chaptersContainer);
      // console.log('chaptersHeight', chaptersHeight);
      console.log('---', Menu.chaptersStickyPoint - headerHeight, Menu.chaptersStickyPoint, headerHeight);

      if (scrollTop > Menu.chaptersStickyPoint - headerHeight) {
        if (!Menu.chapters.hasClass('sticky')) {
          Menu.chapters.css('height', chaptersHeight + 'px')
          $chaptersContainer.css('top', headerHeight + 'px')
          Menu.chapters.addClass('sticky')
        }
      } else {
        Menu.chapters.css('height', 'auto')
        $chaptersContainer.css('top', 'auto')
        Menu.chapters.removeClass('sticky')
      }
    }

    Menu.chapter_items.each(function(index) {
      let $item = $(this)
      let targetTop = Menu.chapter_offsets[index]
      let targetBottom = Menu.chapter_offsets[index+1]
      let $progress = $item.children('.progress')

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

$(document).on('turbolinks:load', function() { Menu.load() })
