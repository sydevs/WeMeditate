/** SUBTLE SYSTEM
 * The Subtle System page include an interactive chart, this file defines behaviour for that chart.
 */

const SubtleSystem = {
  // To be defined on load
  context: null,
  active_node: '',
  timeout: null,

  scrollCutoff: 768,

  // Called when turbolinks loads the page
  load() {
    console.log('loading SubtleSystem.js')
    SubtleSystem.active_node = ''
    SubtleSystem.context = $('section.type-special.format-subtle-system')
    SubtleSystem.context.find('.filter-button').click(SubtleSystem._on_filter_click)
    SubtleSystem.context.find('.subtle-system-trigger').mouseover(SubtleSystem._on_trigger_mouseover)
    SubtleSystem.context.find('.subtle-system-trigger').mouseout(SubtleSystem._on_trigger_mouseout)
  },

  // Called before turbolinks loads the next page
  unload() {
    console.log('unloading SubtleSystem.js')
    $(SubtleSystem.active_node).removeClass('active')
  },

  // Triggered when one of the chart tabs/filters below the chart is clicked on.
  // This allows us to switch between the two different versions of the chart.
  _on_filter_click() {
    console.log('click', this)
    var filter = $(this).data('filter')
    SubtleSystem.context.find('.active').removeClass('active')
    SubtleSystem.context.find(filter).addClass('active')
    $(this).addClass('active')
  },

  // Triggered with a chakra/channel is hovered over.
  _on_trigger_mouseover() {
    console.log('mouseover', this)
    //clearTimeout(SubtleSystem.timeout)
    let new_active_node = '.' + $(this).data('trigger')

    if (new_active_node != SubtleSystem.active_node) {
      // Some of the nodes are contained within other notes, so for some nodes,
      // we use a timer to make sure that the person really wants to select the node they are hovering on.
      let time = 0

      if ((SubtleSystem.active_node == '.chakra-2' || SubtleSystem.active_node == '.chakra-3') && new_active_node == '.chakra-3b') {
        time = 300
      } else if (SubtleSystem.active_node == '.chakra-3b' && (new_active_node == '.chakra-2' || new_active_node == '.chakra-3')) {
        time = 300
      }

      SubtleSystem.timeout = setTimeout(function() {
        // Select the new node, and deleselect the old one.
        $(SubtleSystem.active_node).removeClass('active')
        SubtleSystem.active_node = new_active_node
        $(SubtleSystem.active_node).addClass('active')

        // If we are on mobile, scroll down to the description of the node we just selected.
        if ($(window).width() <= SubtleSystem.scrollCutoff) {
          var $target = $('#' + SubtleSystem.context.find('.active.subtle-system-item').attr('id'))
          var position = $target.offset().top - $(window).height() + $target.height() + 30

          Menu.scroll.animateScroll(position, 4000, {
            speed: 4000,
            updateURL: false,
          })
        }
      }, time)
    }
  },

  // Triggered when the user stops hovering over a particular chakra/channel.
  _on_trigger_mouseout() {
    console.log('mouseout', this)
    // Clear the timeout because we don't want to select this node after all.
    clearTimeout(SubtleSystem.timeout)
    SubtleSystem.timeout = null
  },
}

$(document).on('turbolinks:load', () => { SubtleSystem.load() })
$(document).on('turbolinks:before-cache', () => { SubtleSystem.unload() })
