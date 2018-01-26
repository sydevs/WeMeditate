
$(document).on('turbolinks:load', function() {
  $('body').on('change', '.section .content-type.field select', function() {
    var section = $(this).closest('.section')
    
    section.removeClass(function (index, className) {
      return (className.match (/(^|\s)type-\S+/g) || []).join(' ')
    });

    section.addClass('type-' + $(this).children("option").filter(":selected").val())
  })

  $('body').on('change', '.section .delete-section', function() {
    var section = $(this).closest('.section')
    section.toggleClass('deleting', this.checked)

    if (this.checked) {
      section.accordion('close', 0)
    }
  })

  $('[data-form-prepend]').click(function(e) {
    var obj = $($(this).attr('data-form-prepend'))

    obj.find('input, select, textarea').each(function() {
      $(this).attr('name', function() {
        return $(this).attr('name').replace('new_record', (new Date()).getTime())
      })
    })

    // TODO: Remove this temp code
    obj.accordion()
    obj.find('.ui.dropdown').dropdown()

    obj.insertBefore(this)
    return false
  })
})
