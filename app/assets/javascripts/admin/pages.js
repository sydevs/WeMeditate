
$(document).on('turbolinks:load', function() {
  $('body').on('change', '.section .content-type.field input', function() {
    var section = $(this).closest('.section')
    
    section.removeClass(function (index, className) {
      return (className.match (/(^|\s)(format|type)-\S+/g) || []).join(' ')
    });

    content_type = $(this).val()
    section.addClass('type-' + content_type)

    format = $('.section .format.for.'+content_type+' option:selected').val()
    section.addClass('format-' + format)
  })

  $('body').on('change', '.section .format.field select', function() {
    var section = $(this).closest('.section')
    
    section.removeClass(function (index, className) {
      return (className.match (/(^|\s)format-\S+/g) || []).join(' ')
    });

    section.addClass('format-' + $(this).children("option").filter(":selected").val())
  })

  $('body').on('click', '[data-form-prepend]', function(e) {
    var obj = $($(this).attr('data-form-prepend'))
    var id = (new Date()).getTime()

    obj.find('input, select, textarea').each(function() {
      $(this).attr('name', function() {
        return $(this).attr('name').replace('new_record', id)
      })
    })

    // TODO: Remove this temp code
    obj.accordion('open', 0)
    obj.find('.ui.dropdown').dropdown()

    obj.insertBefore(this)
    return false
  })

  $('body').on('change', '.child .delete-child', function() {
    var child = $(this).closest('.child')
    child.toggleClass('deleting', this.checked)

    if (this.checked) {
      child.accordion('close', 0)
    }
  })
  
  $('body').on('click', '.remove-child-button', function() {
    $(this).closest('.child').remove()
  })
})
