/** DROPDOWN
 * This file implements a generic dropdown where items can use markup. This is not a select element.
 * This is used on the Meditations index page.
 */

const Dropdown = {
  // Called when turbolinks loads the page
  load() {
    console.log('loading Dropdown.js')
    $root = $('body')
    $root.on('click', '.dropdown-selection', Dropdown._on_click_dropdown)
    $root.on('click', '.dropdown-popup-close', Dropdown._on_toggle_dropdown)
    $root.on('click', '.dropdown-popup li', Dropdown._on_select_item)
  },

  // Triggered when the dropdown selection is clicked on.
  _on_click_dropdown(e) {
    $dropdown = $(e.currentTarget).closest('.dropdown')
    Dropdown.toggle_popup($dropdown)
  },

  // Triggered when a dropdown item is selected
  _on_select_item(e) {
    let $target = $(e.currentTarget)
    let $dropdown = $target.closest('.dropdown')
    let $selection = $dropdown.children('.dropdown-selection')
    $target.siblings('.active').removeClass('active')
    $target.addClass('active')

    let $svg = $target.children('svg')
    let color = $svg.data('color')
    let text = $target.children('.dropdown-popup-text').text()

    $dropdown.children('input').val($target.data('value'))
    $selection.children('.dropdown-text').text(text).css('color', color)
    $selection.find('.dropdown-icon > svg').replaceWith($svg.clone())
    $selection.removeClass('disabled')

    Dropdown.toggle_popup($dropdown) // Close it
  },

  // Open the dropdown popup if it is closed, and vice versa.
  toggle_popup($dropdown) {
    $dropdown.toggleClass('expand')
    $('body').toggleClass('noscroll')
  },
}

$(document).on('turbolinks:load', () => { Dropdown.load })
