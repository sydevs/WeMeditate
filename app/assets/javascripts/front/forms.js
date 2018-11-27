
const Forms = {

  load: function() {
    $('form[data-remote]').on('ajax:beforeSend', Forms._on_submit_form)
  },

  _on_submit_form: function() {
    Forms.set_form_loading($(this), true)
  },

  set_form_loading: function($form, enabled) {
    $form.toggleClass('loading', enabled)
    $form.find('input, textarea, select').attr('disabled', enabled ? 'disabled' : false)
    $form.find('button').toggleClass('disabled', enabled)

    if (enabled) {
      $form.children('.message').removeClass('negative').addClass('positive').text('Loading...').show()
    }
  }
}

$(document).on('turbolinks:load', function() { Forms.load() })
