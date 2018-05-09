class RichTextInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div) do
      template.concat @builder.hidden_field(attribute_name, input_html_options)
      template.concat rich_text_editor
    end
  end

  def rich_text_editor
    template.content_tag(:div, class: 'rich-text-editor') do
      template.concat object.send(attribute_name)&.html_safe
    end
  end
end
