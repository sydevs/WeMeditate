
var Autocomplete = {
  load: function() {
    console.log('loading Autocomplete.js')

    $('.country.autocomplete').each(Autocomplete._on_load_country_autocomplete)
  },

  _on_load_country_autocomplete: function() {
    new Awesomplete(this, {
      minChars: 0,
      maxItems: 5,
      autoFirst: true
    })

    $(this).on('awesomplete-select', function(event) {
      let selection = event.originalEvent.text
      $(this).val(selection.label)
      console.log('url', selection.value)
      window.location.href = selection.value
      event.preventDefault()
    })
  },
}

$(document).on('turbolinks:load', function() { Autocomplete.load() })
