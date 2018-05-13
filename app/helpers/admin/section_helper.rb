module Admin::SectionHelper

  CONTENT_TYPE_TO_ICON_MAP = {
    text: 'font',
    quote: 'quote right',
    video: 'play',
    image: 'photo',
    action: 'mouse pointer',
    special: 'star',
  }

  def content_type_icon ct
    content_tag :i, nil, class: "#{CONTENT_TYPE_TO_ICON_MAP[ct]} icon"
  end

  def decoration_type_input f, decoration
    f.input decoration, {
      label: decoration_type_label(decoration),
      as: :boolean,
      wrapper: :ui_checkbox,
      checked_value: decoration.to_s,
      unchecked_value: '',
      required: false,
      input_html: {
        name: "#{f.object_name}[decorations][enabled][]",
        checked: f.object.has_decoration?(decoration),
      },
    }
  end

  def decoration_config_dropdown f, decoration, attribute, options
    content_tag :div, class: 'ui inline dropdown' do
      result = hidden_field_tag "#{f.object_name}[decorations][options][#{decoration}][]", (options & f.object.decoration_options(decoration))[0]
      result.concat content_tag(:i, nil, class: 'dropdown icon')
      result.concat content_tag(:div, decoration_option_label(attribute), class: 'default text')
      menu = content_tag(:div, class: 'menu') do
        options.collect { |value|
          concat content_tag(:div, decoration_option_label(attribute, value), class: 'item', data: { value: value })
        }
      end

      result.concat(menu)
    end
  end

  def decoration_type_label type
    I18n.translate "activerecord.attributes.section.decoration_types.#{type}"
  end

  def decoration_option_label option, value = nil
    if value
      I18n.translate "activerecord.attributes.section.decoration_options.#{option.to_s.pluralize}.#{value}"
    else
      I18n.translate "activerecord.attributes.section.decoration_options.#{option.to_s}"
    end
  end
end
