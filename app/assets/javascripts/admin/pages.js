
$(document).on('turbolinks:load', function() {
  $('body').on('change', '.section .content-type.field input', function() {
    var section = $(this).closest('.section')

    section.removeClass(function (index, className) {
      return (className.match (/(^|\s)(format|type)-\S+/g) || []).join(' ')
    });

    content_type = $(this).val()
    section.addClass('type-' + content_type)

    format = $('.section .fields.for.'+content_type+' .field-format option:selected').val()
    section.addClass('format-' + format)
  })

  $('body').on('change', '.section .field-format select', function() {
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

    $('.ui.accordion').accordion('close', 0)
    obj.find('.ui.dropdown').dropdown() // TODO: Remove this temp code
    obj.insertBefore(this)
    obj.accordion('open', 0) // TODO: Remove this temp code

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

  $('#page-form').on('submit', function() {
    $('.ui.accordion').accordion('close', 0)

    $(this).find('.section').each(function() {
      var content_type = $(this).find('.static_page_sections_content_type select').val()
      if (typeof content_type !== 'undefined') {
        $(this).find('.grouped.fields.for:not(.'+content_type+') :input').attr('disabled', true)
      }
    })
  })
})
