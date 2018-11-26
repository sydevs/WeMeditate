var Meditation = {
  // These variables will be set on load
  video_player: null,
  goal_dropdown: null,

  load: function () {
    console.log('loading Meditation.js')
    let $context = $('section.type-special.format-custom-meditation').first()
    Meditation.goal_dropdown = $context.find('.dropdown')
    Meditation.video_player = new Plyr('#meditation-player')

    $context.find('.active-goal').on('click', Meditation.toggle_dropdown)
    Meditation.goal_dropdown.on('click', '.close-button', Meditation.toggle_dropdown)
    Meditation.goal_dropdown.on('click', 'li', Meditation._on_select_goal)
  },

  set_active_goal: function($goal) {
    let $svg = $goal.children('svg')
    let color = $goal.children('svg').data('color')
    let text = $goal.children('.text').text()

    console.log($goal.children('svg'), color)

    $('.active-goal > .text').text(text).css('color', color)
    $('.active-goal > .icon > svg').replaceWith($svg.clone())
    $('[name="goal_filter"]').val($goal.data('value'))

    Meditation.toggle_dropdown()
  },

  _on_select_goal: function(event) {
    let $target = $(this)
    Meditation.goal_dropdown.find('li').removeClass('active')
    $target.addClass('active')
    Meditation.set_active_goal($target)
    $('.active-goal').removeClass('disabled')
  },

  toggle_dropdown: function() {
    Meditation.goal_dropdown.parent().toggleClass('open')
    $('body').toggleClass('noscroll')
  },
}

$(document).on('turbolinks:load', Meditation.load)
