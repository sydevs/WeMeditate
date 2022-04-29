## VIEWABLE CONCERN
# This concern should be added to models have their own page on the public-facing site.

module Viewable

  extend ActiveSupport::Concern

  def viewable?
    true
  end

  included do |base|
    translatable = base.respond_to?(:translated_attribute_names)

    %i[slug metatags].each do |column|
      next if base.try(:translated_attribute_names)&.include?(column) || base.column_names.include?(column.to_s)
      throw "Column `#{column}` must be defined to make the `#{base.model_name}` model `Viewable`"
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid # rubocop:disable Lint/HandleExceptions
      # avoid breaking rails db:create / db:drop etc due to boot time execution
    end

    base.extend FriendlyId
    base.friendly_id :name, use: [(translatable ? :globalize : :slugged), :history]
    base.validates :slug, length: { minimum: 3, message: I18n.translate('admin.messages.text_too_short', count: 3) }

    def self.viewable?
      true
    end
  end

  # Some records cannot have their slug (aka URL) changed, this checks to see if the record is one of those.
  def fixed_slug?
    case self
    when StaticPage
      true
    when Meditation
      slug == I18n.translate('routes.self_realization')
    else
      false
    end
  end

end
