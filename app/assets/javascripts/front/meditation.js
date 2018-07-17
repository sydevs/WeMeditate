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
		Meditation.goals_wrap = $('.select-meditation .goals')
		Meditation.goals = $('.select-meditation .dropdown li')

		Meditation.select.on('click', '.active-goal', Meditation.toggle_dropdown)
		Meditation.goals.on('click', Meditation.toggle_active_goal)
		Meditation.dropdown_close.on('click', Meditation.close_dropdown)

		Meditation.init_close_dropdown_listener()
		Meditation.set_goal_icon()
		Meditation._on_mobile()

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
				console.log('!!!',$(item), text, color);
			}
		})

		$('.active-goal-text').text(text).css('color', color)
		$('.active-goal-icon').find('svg').remove()
		img.clone().appendTo($('.active-goal-icon'));

		$('[name="i-feel"]').val(text)

		if ($(window).width() < 991) {
			Meditation.close_dropdown()
		}
	},

	toggle_active_goal: function () {
		Meditation.goals.removeClass('active')
		Meditation.goals.find('svg').removeClass('invert').attr('style', '')
		$(this).addClass('active')
		Meditation.set_active_goal()
		if ($('.active-goal').hasClass('disable')) {
			$('.active-goal').removeClass('disable')
		}
	},

	close_dropdown: function () {
		Meditation.goals_wrap.removeClass('open')
	},

	init_close_dropdown_listener: function () {
		$(document).click(function (e) {
			if (!$(e.target).closest('.goals').length) {
				if (Meditation.goals_wrap.hasClass('open')) {
					Meditation.close_dropdown()
				}
			}
		})
	},

	toggle_dropdown: function (e) {
		$(this).parent().toggleClass('open')

	},

	_on_mobile: function () {
		if ($(window).width() < 991) {
			$('.meditation-video .grid-row').slick({
				dots: true
			})
		}
	},

	_get_goal_icon: function (container, url, add_class) {
		let svg

		$.get(url, function (data) {
			if (data.rootElement.innerHTML.includes('<style>')) {
				el = data.rootElement
				el.innerHTML = el.innerHTML.replace("<style>",`<style>.${add_class} `)
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
