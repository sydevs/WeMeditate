/** FORMS
 * Handles forms on the public-facing side of the website.
 * Primarily it handles the loading state for remote forms.
 */

const Forms = {
  // Called when turbolinks loads the page
  load() {
    $('form[data-remote]').on('ajax:beforeSend', Forms._on_submit_form)
  },

  // Triggered when a remote form is submitted.
  _on_submit_form() {
    Forms.set_form_loading($(this), true)
  },

  // Allows a form to be set as loading or not loading.
  set_form_loading($form, enabled) {
    $form.toggleClass('loading', enabled)
    $form.find('input, textarea, select').attr('disabled', enabled ? 'disabled' : false)
    $form.find('button').toggleClass('disabled', enabled)

    if (enabled) {
      $form.children('.message').removeClass('negative').addClass('positive').text('Loading...').show()
    }
  }
}

$(document).on('turbolinks:load', () => { Forms.load() })
