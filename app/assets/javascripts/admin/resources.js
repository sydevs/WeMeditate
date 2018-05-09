
let Resources = {
  load: function() {
    console.log('Load Resources.js')
    $('.resource.items').on('click', '.edit.button', Resources._on_edit_click)
    $('.resource.items').on('click', '.save.button', Resources._on_save_click)
  },

  _on_edit_click: function() {
    $(this).closest('.item').toggleClass('editing')
  },

  _on_save_click: function() {
    $(this).closest('form').addClass('loading')
  },
}

$(document).on('turbolinks:load', function() {
  if ($('.resource.items').length > 0) {
    Resources.load()
  }
})
