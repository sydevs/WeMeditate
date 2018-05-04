
const SubtleSystem = {
  // To be defined on load
  sections: null,
  chakras_chart: null,
  channels_chart: null,
  active_node: '',

  load: function() {
    console.log('loading SubtleSystem.js')
    SubtleSystem.active_node = ''
    SubtleSystem.sections = $('section.type-special.format-subtle-system')
    SubtleSystem.sections.find('.filter').click(SubtleSystem._on_filter_click)
    SubtleSystem.sections.find('.trigger').mouseover(SubtleSystem._on_trigger_mouseover)
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
    //$(SubtleSystem.active_node).stop().fadeOut('slow') //.removeClass('active')

    $(SubtleSystem.active_node).removeClass('active')
    SubtleSystem.active_node = '.' + $(this).data('class')

    setTimeout(function() {
      $(SubtleSystem.active_node).addClass('active')
      //$(SubtleSystem.active_node).stop().fadeIn('slow') //.addClass('active')
    }, 300)
  }

}

$(document).on('turbolinks:load', function() { SubtleSystem.load() })
