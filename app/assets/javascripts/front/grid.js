/** GRID
 * We use the Isotope library to implement responsive and sortable grids/columns.
 * This file initializes those grids and handles other features like filtering.
 */

const Grid = {
  containers: {}, // To be defined on load
  active_filters: {},

  // Called when turbolinks loads the page
  load() {
    console.log('loading Grid.js')
    Grid.container = $('#grid')
    Grid.active_filters = {} // Clear the filters list

    $('.grid').each(function() {
      let $container = $(this)
      let id = $container.attr('id')
      Grid.containers[id] = $container

      // Wait until all images are loaded before initialize the grid, to avoid sizing issues.
      $container.imagesLoaded(function() {
        let filter = $container.data('filter')

        // Initialize Isotope
        $container.isotope({
          filter: (typeof filter === 'undefined' ? '*' : filter),
          itemSelector: '.grid-item',
          percentPosition: true,
          masonry: {
            columnWidth: '.grid-sizer',
          }
        })

        $('.filter-group[data-for="'+id+'"]').each(Grid._init_filter_group)
      })
    })
  },

  // Initialize a given group of filters
  _init_filter_group() {
    const $group = $(this)
    const group = this.dataset.group
    const allow_multiple = (typeof this.dataset.multiple !== 'undefined')
    const grid = this.dataset.for

    Grid.active_filters[grid] = {}

    // Detect any existing selected filters.
    $group.children('a').each(function() {
      if ($(this).hasClass('active')) {
        Grid.toggle_filter_by(grid, group, this.dataset.filter, allow_multiple)
      }
    })

    // When a filter clicked, trigger the appropriate handler
    $group.children('a').on('click', function(e) {
      Grid._on_filter_click.call(this, e, grid, group, allow_multiple)
      $group.removeClass('show-menu') // and hide the menu if we are using mobile
    })

    // Open the mobile menu when the button is clicked.
    $group.children('.filter-menu-button').on('click', function(e) {
      $group.addClass('show-menu')
    })
  },

  // Triggered when a filter is clicked
  _on_filter_click(e, grid, group, allow_multiple) {
    // Call another function to implement the filter.
    let active = Grid.toggle_filter_by(grid, group, this.dataset.filter, allow_multiple)

    if (!allow_multiple && active) {
      // If multiple filters are not allowed for this group, then deactivate the currently active filter.
      $(this).siblings('.active').removeClass('active')
    }

    // Set the the new filter to active or not.
    $(this).toggleClass('active', active)
    e.preventDefault()
  },

  // Toggles a filter on or off, and return the on/off state of the filter.
  // `group` is the name of the filter group we are operating on.
  // `filter` is the name of the filter we are enabling/disabling
  // `allow_multiple` signals whether other filters in this group can be active at the same time.
  toggle_filter_by(grid, group, filter, allow_multiple) {
    let current_filter = Grid.active_filters[grid][group]
    let active = true

    // Configure the current filter.
    if (allow_multiple) {
      // If multiple filters are allowed, we must handle it as an arrow.
      if (Array.isArray(current_filter)) {
        const index = $.inArray(filter, current_filter)
        if (index === -1) {
          // If the filter is not already active, add it to the array.
          current_filter.push(filter)
        } else {
          // If the filter is already active, remove it from the array.
          current_filter.splice(index, 1)
          active = false
        }
      } else {
        // If the filter is not properly configured replace it.
        current_filter = [filter]
      }
    } else {
      // If multiple filters are not allowed...
      if (current_filter == filter && current_filter != '') {
        // If the filter is already active, deactivate it.
        current_filter = null
        active = false

        // Also, toggle the all filter button off.
        $('[data-group="'+group+'"] > .all.filter-button').click()
      } else {
        // Otherwise just replace the existing filter.
        current_filter = filter
      }
    }

    Grid.active_filters[grid][group] = current_filter
    Grid.apply_filters(grid)
    return active
  },

  // Use Isotope to apply all existing filters that have been set.
  apply_filters(grid) {
    let filters = []

    for (let key in Grid.active_filters[grid]) {
      if (Array.isArray(Grid.active_filters[grid][key])) {
        filters = filters.concat(Grid.active_filters[grid][key])
      } else {
        filters.push(Grid.active_filters[grid][key])
      }
    }

    console.log('Filter', grid, 'by', filters.join(''))

    // Make the final call to Isotope
    Grid.containers[grid].isotope({
      filter: filters.join(''),
    })
  },

}

$(document).on('turbolinks:load', () => { Grid.load() })
