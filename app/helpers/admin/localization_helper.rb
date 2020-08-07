
module Admin::LocalizationHelper

  # Fetch the translated version of a model name.
  def human_model_name model, pluralization = :singular
    key = pluralization == :plural ? 'other' : 'one'
    translate(key, scope: [:activerecord, :models, model.model_name.i18n_key])
  end

  # Fetch the translated version of an enum's value.
  # If no value is provided, this method will get the current value from the given model.
  # If a value is provided then `model` can be a class instead of an ActiveRecord object.
  def human_enum_name model, attr, value = nil
    value ||= model.send(attr)
    value = (model.is_a?(Class) ? model : model.class).send(attr.to_s.pluralize).key(value) if value.is_a?(Integer)
    I18n.translate value, scope: [:activerecord, :attributes, model.model_name.i18n_key, attr.to_s.pluralize]
  end

  # Fetch the translated version of a model's attribute
  # `model` can either be a class or an ActiveRecord object, doesn't matter.
  def human_attribute_name model, attr
    I18n.translate attr, scope: [:activerecord, :attributes, model.model_name.i18n_key]
  end

end
