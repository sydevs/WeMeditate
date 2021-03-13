## STATEABLE CONCERN
# This concern should be added to models that can have multiple states

module Stateable

  extend ActiveSupport::Concern

  NEVER_PUBLISHED_ALLOWED_STATES = %i[in_progress published archived].freeze
  POST_PUBLISHED_ALLOWED_STATES = %i[published unpublished in_progress archived].freeze

  def stateable?
    true
  end

  included do |base|
    translatable = base.respond_to?(:translated_attribute_names)

    %i[state published_at].each do |column|
      next if base.try(:translated_attribute_names)&.include?(column) || base.column_names.include?(column.to_s)
      throw "Column `#{column}` must be defined to make the `#{base.model_name}` model `Stateable`"
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid # rubocop:disable Lint/HandleExceptions
      # avoid breaking rails db:create / db:drop etc due to boot time execution
    end

    base.enum state: {
      no_state: 0,
      in_progress: 1,
      archived: 2,
      published: 3,
      unpublished: 4,
    }

    base.before_validation :set_published_at, if: :published?
    base.validates_presence_of :published_at, if: :published?
    base.validates_presence_of :state

    if translatable
      base.scope :published, -> { with_translation.where(state: base.states[:published]) }
      base.scope :publicly_visible, -> { published.where("#{base::Translation.table_name}.published_at <= ?", DateTime.now) }
      base.scope :not_published, -> { with_translation.where.not(state: base.states[:published]) }
      base.scope :not_archived, -> { with_translation.where.not(state: base.states[:archived]) }
    else
      base.scope :published, -> { where(state: base.states[:published]) }
      base.scope :publicly_visible, -> { published.where('published_at <= ?', DateTime.now) }
      base.scope :not_published, -> { where.not(state: base.states[:published]) }
      base.scope :not_archived, -> { where.not(state: base.states[:archived]) }
    end

    def state
      if respond_to?(:get_native_locale_attribute)
        value = get_native_locale_attribute(:state)
        self.class.states.key(value)
      else
        super
      end
    end

    def state= value
      self[:state] = self.class.states[value.to_s]
    end

    def published?
      state&.to_sym == :published
    end

    def self.stateable?
      true
    end
  end

  def avaliable_states
    published_at = respond_to?(:get_native_locale_attribute) ? get_native_locale_attribute(:published_at) : send(:published_at)

    if published_at.present? || POST_PUBLISHED_ALLOWED_STATES.include?(state)
      result = POST_PUBLISHED_ALLOWED_STATES
    else
      result = NEVER_PUBLISHED_ALLOWED_STATES
    end

    result -= %i[archived unpublished] unless unpublishable?
    result
  end

  # This is a temporary workaround to prevet unpublishing of certain types.
  # TODO: Rework this so that anything with a fixed slug cannot be unpublished.
  def unpublishable?
    return false if is_a?(StaticPage) || is_a?(SubtleSystemNode)
    return false if is_a?(Meditation) && self_realization?

    true
  end

  private

    def set_published_at
      self.published_at ||= DateTime.now
    end

end
