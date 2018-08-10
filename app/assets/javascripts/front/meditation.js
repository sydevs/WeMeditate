var Meditation = {
  // These variables will be set on load
  audio_player: null,
  goal_dropdown: null,

  load: function () {
    console.log('loading Meditation.js')
    //var player = $('audio#audio-player')
    //Meditation.audio_player = new Plyr('audio#audio-player', player.data('controls'))

    let $context = $('section.type-special.format-custom-meditation').first()
    Meditation.goal_dropdown = $context.find('.dropdown')

    $context.find('.active-goal').on('click', Meditation.toggle_dropdown)
    Meditation.goal_dropdown.on('click', '.close-button', Meditation.toggle_dropdown)
    Meditation.goal_dropdown.on('click', 'li', Meditation._on_select_goal)

    Meditation.goal_dropdown.find('li').each(function () {
      let $element = $(this)
      let url = $element.data('image-url')
      let text = $element.text()

      $.ajax({
        url: url,
        dataType: 'text',
        type: 'GET',
        error: function (jqXHR, status, errorThrown) {
          alert('error')
        }
      }).done(function(svg) {
        if (svg.includes('<style>')) {
          svg = svg.replace("<style>", "<style>." + text + " ")
        }

        let $svg = $(svg).addClass(text).appendTo($element)
        let path = $svg.find('path')
        let color = path.css('fill') === 'none' ? path.css('stroke') : path.css('fill')
        $svg.css('background-color', color)
        $element.data('color', color)
      })
    })
  },

  set_active_goal: function($goal) {
    let $svg = $goal.children('svg')
    let color = $goal.data('color')
    let text = $goal.children('.text').text()

    $('.active-goal > .text').text(text).css('color', color)
    $('.active-goal > .icon > svg').replaceWith($svg.clone())
    $('[name="goal_filter"]').val($goal.data('value'))

    Meditation.toggle_dropdown()

    if ($(window).width() < 740) {
      $('html,body').animate({
        scrollTop: $('.format-custom-meditation').offset().top - 80
      }, 0);
    }

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
