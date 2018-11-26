
var Autocomplete = {
  load: function() {
    console.log('loading Autocomplete.js')
    $('.country.autocomplete').each(Autocomplete._on_load_country_autocomplete)
    $('.classes.autocomplete').each(Autocomplete._on_load_classes_autocomplete)
  },

  unload: function() {
    console.log('unloading Autocomplete.js')
    Awesomplete.all.forEach(instance => {
      $input = $(instance.input)
      instance.destroy()
      $input.replaceWith($input.data('original'))
    })

    Awesomplete.count = 0
  },

  create: function(input, settings) {
    var original = input.outerHTML
    var awesomplete = new Awesomplete(input, settings)
    $(awesomplete.input).data('original', original)
    return awesomplete
  },

  _on_load_classes_autocomplete: function() {
    var $input = $(this)

    var awesomplete = Autocomplete.create(this, {
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

    var awesomplete = Autocomplete.create(this, {
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
    Turbolinks.visit(selection.value)
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
$(document).on('turbolinks:before-cache', function() { Autocomplete.unload() })
