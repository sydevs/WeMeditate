
/** AUTOCOMPLETE
 * Creates support for autocompleting inputs, via an integration with the awesomplete library.
 * When a user selects an autocomplete input or starts typing in it, a list of suggestions will be shown.
 * What exactly happens when a suggestion is chosen depends on the specific autocomplete instance. (See below)
 */

const Autocomplete = {
  // Called when turbolinks loads the page
  load() {
    console.log('loading Autocomplete.js')
    $('.country.autocomplete').each(Autocomplete._on_load_country_autocomplete)
    $('.classes.autocomplete').each(Autocomplete._on_load_classes_autocomplete)
  },

  // Called before turbolinks loads the next page
  unload() {
    console.log('unloading Autocomplete.js')
    // Remove all instance of awesomplete, and replace it with the original markup.
    Awesomplete.all.forEach(instance => {
      $input = $(instance.input)
      instance.destroy()
      $input.replaceWith($input.data('original'))
    })

    // Reset the number of instances that Awesomplete things we have.
    Awesomplete.count = 0
  },

  // Creates an instance of an autocomplete, on a target input
  create(input, settings) {
    var original = input.outerHTML
    var awesomplete = new Awesomplete(input, settings)
    $(awesomplete.input).data('original', original) // Preserve the original markup so that we can unload this.
    return awesomplete
  },

  // Triggered when a classes-type autocomplete should be loaded
  _on_load_classes_autocomplete() {
    var $input = $(this)

    // Create the awesomplete instance
    var awesomplete = Autocomplete.create(this, {
      minChars: 0,
      maxItems: 10,
      autoFirst: true
    })

    $input.on('focus', function(event) {
      if (this.value == '') {
        // Show suggestions even before they start typing.
        awesomplete.evaluate()
      } else {
        // If there is already a value, make sure that value is chosen.
        $(this).select()
      }
    })

    // When a choice is clicked on prevent awesomplete from selecting the entire text.
    $input.on('mouseup', function(event) {
      event.preventDefault()
    })
  },

  // Triggered when a country-type autocomplete should be loaded
  _on_load_country_autocomplete() {
    var $input = $(this)

    // Create the awesomplete instance
    var awesomplete = Autocomplete.create(this, {
      minChars: 0,
      maxItems: 5,
      autoFirst: true
    })

    $input.on('focus', function(event) { awesomplete.evaluate() }) // Show a list of suggestions even before the user starts typing.
    $input.on('awesomplete-select', Autocomplete._on_autocomplete_select)
    $input.on('awesomplete-open', Autocomplete._on_autocomplete_open)
    $input.on('awesomplete-close', Autocomplete._on_autocomplete_close)
  },

  // When a country autocomplete item is selected, navigate to that country page/value.
  _on_autocomplete_select(event) {
    console.log(event)
    let selection = event.originalEvent.text
    let $input = $(this)
    $input.val(selection.label).blur()
    $input.attr('disabled', true)
    Turbolinks.visit(selection.value)
    event.preventDefault()
  },

  // When the autocomplete list is opened/created, hide the "no results" message.
  _on_autocomplete_open(event) {
    $(this).closest('.action').removeClass('no-results')
  },

  // When the autocomplete list is closed/hidden, show the "no results" message if relevant.
  _on_autocomplete_close(event, test) {
    if (event.originalEvent.reason == 'nomatches') {
      $(this).closest('.action').addClass('no-results')
    }
  },
}

$(document).on('turbolinks:load', function() { Autocomplete.load() })
$(document).on('turbolinks:before-cache', function() { Autocomplete.unload() })
