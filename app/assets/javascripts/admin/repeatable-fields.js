
let RepeatableFields = {

  attribute_name_regex: /\[([\w_]+)\]\[\]$/,

  initialize: function(scope) {
    scope.find('.repeatable.fields').each(function() {
      $(this).repeatable_fields({
        //row_count_placeholder: '{{row-count-placeholder}}',
        remove: '.remove',
        move_up: '.move-up',
        move_down: '.move-down',
        is_sortable: true,
        after_add: RepeatableFields._on_add,
      })
    })
  },

  reset($fieldset, values) {
    let $container = $fieldset.find('.container')
    let $template = $container.find('.template').clone().removeClass('template').show()

    $template.find(':input').each(function() {
      $(this).prop('disabled', false);
    });

    $container.children('.row:not(.template)').remove()

    values.forEach(function(data) {
      let $row = $template.clone()
      let $fields = $row.children('.fields-wrapper').children()

      $fields.each(function() {
        if (this.tagName == 'INPUT' || this.tagName == 'TEXTAREA') {
          let key = RepeatableFields.attribute_name_regex.exec(this.name)[1]
          this.value = data[key]
        } else if (this.className = 'ui media input') {
          Media.set_input($(this))
          let name = Media.allow_multiple_selection ? translate['files'] : translate['file']
          Media.set_value({ name: name, value: data[this.dataset.key], url: undefined })
        } else {
          console.error('Resetting', this.tagName, 'fields is currently not supported for repeatable fields.')
        }
      })

      RepeatableFields._on_add($container[0], $row)
      $container.append($row)
    })
  },

  _on_add(_container, $new_row) {
    Admin.initialize($new_row)
  },
}

console.log('loading Repeatable Fields.js')
