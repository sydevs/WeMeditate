# Some tweaks to the collection select input, to support Semantic UI (our CSS framework)
class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput

  def input_html_classes
    super.push 'ui selection dropdown'
  end

end
