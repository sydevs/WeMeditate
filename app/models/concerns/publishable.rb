## PUBLISHABLE CONCERN
# This concern should be added to models that can be published with a simple toggle

module Publishable

  extend ActiveSupport::Concern

  def publishable?
    true
  end

  included do |base|
    %i[published published_at].each do |column|
      next if base.translated_attribute_names&.include?(column) || base.column_names.include?(column.to_s)

      throw "Column `#{column}` must be defined to make the `#{base.model_name}` model `Publishable`"
    end

    base.before_validation :set_published_at, if: :published?
    base.validates_presence_of :published_at, if: :published?

    base.scope :publicly_visible, -> { published.where("#{base::Translation.table_name}.published_at < ?", DateTime.now) }
    base.scope :published, -> { where(published: true) }
    base.scope :not_published, -> { where.not(published: true) }

    def self.publishable?
      true
    end
  end

  private

    def set_published_at
      self.published_at ||= DateTime.now
    end

end
