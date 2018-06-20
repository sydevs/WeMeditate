
var Autocomplete = {
  load: function() {
    console.log('loading Autocomplete.js')
    $('.country.autocomplete').each(Autocomplete._on_load_country_autocomplete)
    $('.classes.autocomplete').each(Autocomplete._on_load_classes_autocomplete)
  },

  _on_load_classes_autocomplete: function() {
    var $input = $(this)

    var awesomplete = new Awesomplete(this, {
      minChars: 0,
      maxItems: 10,
      autoFirst: true
    })

    $input.on('focus', function(event) {
      if (this.value == '') {
        awesomplete.evaluate()
      } else {
        $(this).select()
      }
    })

    $input.on('mouseup', function(event) {
      event.preventDefault()
    })
  },

  _on_load_country_autocomplete: function() {
    var $input = $(this)

    var awesomplete = new Awesomplete(this, {
      minChars: 0,
      maxItems: 5,
      autoFirst: true
    })

    $input.on('focus', function(event) { awesomplete.evaluate() })
    $input.on('awesomplete-select', Autocomplete._on_autocomplete_select)
    $input.on('awesomplete-open', Autocomplete._on_autocomplete_open)
    $input.on('awesomplete-close', Autocomplete._on_autocomplete_close)
  },

  _on_autocomplete_select: function(event) {
    console.log(event)
    let selection = event.originalEvent.text
    let $input = $(this)
    $input.val(selection.label).blur()
    $input.attr('disabled', true)
    window.location.href = selection.value
    event.preventDefault()
  },

  _on_autocomplete_open: function(event) {
    $(this).closest('.action').removeClass('no-results')
  },

  _on_autocomplete_close: function(event, test) {
    if (event.originalEvent.reason == 'nomatches') {
      $(this).closest('.action').addClass('no-results')
    }
  },
}

$(document).on('turbolinks:load', function() { Autocomplete.load() })
