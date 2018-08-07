var Meditation = {
  // These variables will be set on load
  audio_player: null,

  load: function () {
    console.log('loading Meditation.js')
    var player = $('audio#audio-player')
    Meditation.audio_player = new Plyr('audio#audio-player', player.data('controls'))

    Meditation.select = $('.select-meditation')
    Meditation.dropdown = $('.select-meditation .dropdown')
    Meditation.dropdown_close = $('.select-meditation .dropdown .btn-close')
    Meditation.goals_wrapper = $('.select-meditation .goals')
    Meditation.goals = $('.select-meditation .dropdown li')
    Meditation.slider = $('.featured-meditations .meditation-wrap')

    Meditation.select.on('click', '.active-goal', Meditation.toggle_dropdown)
    Meditation.goals.on('click', Meditation.toggle_active_goal)
    Meditation.dropdown_close.on('click', Meditation.close_dropdown)

    Meditation.init_close_dropdown_listener()
    Meditation.set_goal_icon()
    Meditation._on_mobile()

    $(window).resize(Meditation._on_resize)
    Meditation._on_resize()
  },

  set_goal_icon: function () {
    Meditation.goals.each(function () {
      Meditation._get_goal_icon($(this), $(this).data('img'), $(this).text())
    })
  },

  set_active_goal: function () {
    let img, text, color

    Meditation.goals.each(function (i,item) {
      if ($(item).hasClass('active')) {
        img = $(item).find('svg')
        color = img.find('path').css('fill') === 'none' ? img.find('path').css('stroke') : img.find('path').css('fill')
        text = $(item).find('span').text()
        img.css({'background-color': color}).addClass('invert')
      }
    })

    $('.active-goal-text').text(text).css('color', color)
    $('.active-goal-icon').find('svg').remove()
    img.clone().appendTo($('.active-goal-icon'));

    $('[name="goal_filters"]').val(text.toLowerCase())

    if ($(window).width() < 991) {
      Meditation.close_dropdown()
    }
  },

  toggle_active_goal: function () {
    Meditation.goals.removeClass('active')
    Meditation.goals.find('svg').removeClass('invert').attr('style', '')
    $(this).addClass('active')
    Meditation.set_active_goal()
    if ($('.active-goal').hasClass('disabled')) {
      $('.active-goal').removeClass('disabled')
    }
  },

  close_dropdown: function () {
    Meditation.goals_wrapper.removeClass('open')
    $('body').removeClass('open-menu')

    if ($(window).width() < 740) {
      $('html,body').animate({
        scrollTop: $('.custom-meditation').offset().top - 80
      }, 0);
    }
  },

  init_close_dropdown_listener: function () {
    $(document).click(function (e) {
      if (!$(e.target).closest('.goals').length) {
        if (Meditation.goals_wrapper.hasClass('open')) {
          Meditation.close_dropdown()
        }
      }
    })
  },

  toggle_dropdown: function (e) {
    $(this).parent().toggleClass('open')
    $('body').toggleClass('open-menu')
  },

  init_slick: function () {
    Meditation.slider.slick({
      dots: true
    })
  },

  destroy_slick: function () {
    Meditation.slider.slick('unslick')
  },

  _on_mobile: function () {
    if ($(window).width() < 740) {
      Meditation.init_slick()
    }
  },

  _on_resize: function() {
    if ($(window).width() > 739) {
      if (Meditation.slider.hasClass('slick-initialized')) {
        Meditation.destroy_slick();
      }
      return
    }
    if (!Meditation.slider.hasClass('slick-initialized')) {
      return Meditation.init_slick()
    }
  },

  _get_goal_icon: function (container, url, add_class) {
    let svg

    $.get(url, function (data) {
      if (data.rootElement.innerHTML.includes('<style>')) {
        el = data.rootElement
        el.innerHTML = el.innerHTML.replace("<style>","<style>." + add_class + " ")
        svg = $(el).addClass(add_class)
      } else {
        svg = $(data.rootElement)
      }

      container.children('svg').remove()
      container.append(svg)
    })
  }
}

$(document).on('turbolinks:load', function () {
  Meditation.load()
})
