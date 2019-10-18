## VIEWABLE CONCERN
# This concern should be added to models have their own page on the public-facing site.

module Viewable

  extend ActiveSupport::Concern

  def viewable?
    true
  end

  included do |base|
    %i[slug metatags].each do |column|
      next if base.translated_attribute_names&.include?(column) || base.column_names.include?(column.to_s)
      throw "Column `#{column}` must be defined to make the `#{base.model_name}` model `Viewable`" 
    end

    base.extend FriendlyId
    base.friendly_id :name, use: :globalize
    base.validates :slug, length: { minimum: 3, message: I18n.translate('admin.messages.text_too_short', count: 3) }

    def self.viewable?
      true
    end
  end

end
