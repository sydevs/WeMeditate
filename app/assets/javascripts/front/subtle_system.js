
const SubtleSystem = {
  // To be defined on load
  sections: null,
  chakras_chart: null,
  channels_chart: null,

  load: function() {
    console.log('loading SubtleSystem.js')
    SubtleSystem.sections = $('section.type-special.format-subtle-system')
    SubtleSystem.sections.find('.filter').click(SubtleSystem._on_filter_click)
    console.log(SubtleSystem.sections.find('.filter'))
  },

  _on_filter_click: function() {
    console.log('click', this)
    var filter = $(this).data('filter')
    SubtleSystem.sections.find('.active').removeClass('active')
    SubtleSystem.sections.find(filter).addClass('active')
    $(this).addClass('active')
  },

}

$(document).on('turbolinks:load', function() { SubtleSystem.load() })
