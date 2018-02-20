$(document).on('turbolinks:load', function() {
  console.log('loading inspiration.js')

  var grid = document.getElementById('grid')
  if (grid) {
    salvattore.registerGrid(grid)
  }
})
