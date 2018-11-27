
const SubtleSystem = {
  // To be defined on load
  sections: null,
  chakras_chart: null,
  channels_chart: null,
  active_node: '',
  timeout: null,

  scrollCutoff: 768,

  load: function() {
    console.log('loading SubtleSystem.js')
    SubtleSystem.active_node = ''
    SubtleSystem.sections = $('section.type-special.format-subtle-system')
    SubtleSystem.sections.find('.filter').click(SubtleSystem._on_filter_click)
    SubtleSystem.sections.find('.trigger').mouseover(SubtleSystem._on_trigger_mouseover)
    SubtleSystem.sections.find('.trigger').mouseout(SubtleSystem._on_trigger_mouseout)
  },

  unload: function() {
    $(SubtleSystem.active_node).removeClass('active')
  },

  _on_filter_click: function() {
    console.log('click', this)
    var filter = $(this).data('filter')
    SubtleSystem.sections.find('.active').removeClass('active')
    SubtleSystem.sections.find(filter).addClass('active')
    $(this).addClass('active')
  },

  _on_trigger_mouseover: function() {
    console.log('mouseover', this)
    //clearTimeout(SubtleSystem.timeout)
    let new_active_node = '.' + $(this).data('class')

    if (new_active_node != SubtleSystem.active_node) {
      let time = 0

      if ((SubtleSystem.active_node == '.chakra-2' || SubtleSystem.active_node == '.chakra-3') && new_active_node == '.chakra-3b') {
        time = 300
      } else if (SubtleSystem.active_node == '.chakra-3b' && (new_active_node == '.chakra-2' || new_active_node == '.chakra-3')) {
        time = 300
      }

      SubtleSystem.timeout = setTimeout(function() {
        console.log('select', new_active_node)
        $(SubtleSystem.active_node).removeClass('active')
        SubtleSystem.active_node = new_active_node
        $(SubtleSystem.active_node).addClass('active')

        if ($(window).width() <= SubtleSystem.scrollCutoff) {
          var $target = $('#' + SubtleSystem.sections.find('.active.article').attr('id'))
          console.log('scroll', $target.offset(), '-', $(window).height(), '+', $target.height())
          var position = $target.offset().top - $(window).height() + $target.height() + 30
          Menu.scroll.animateScroll(position, 2000, {
            speed: 2000,
            updateURL: false,
          })
        }
      }, time)
    }
  },

  _on_trigger_mouseout: function() {
    console.log('mouseout', this)
    clearTimeout(SubtleSystem.timeout)
    SubtleSystem.timeout = null
  },

}

$(document).on('turbolinks:load', function() { SubtleSystem.load() })
$(document).on('turbolinks:before-cache', function() { SubtleSystem.unload() })
