## DRAFTABLE CONCERN
# This concern should be added to models that require an admin to approve any update,
# before it is reflected in the public-facing website.

module Draftable

  extend ActiveSupport::Concern

  included do |base|
    # Do nothing for now
  end

  def published?
    published_at != nil
  end

  def has_draft?
    if respond_to? :sections
      sections.where.not(draft: nil).present?
    else
      draft.present?
    end
  end

  def record_draft!
    draft = {}

    changes.each do |key, (old_value, new_value)|
      if key == 'extra'
        self[key] = old_value
        draft[key] = new_value.map { |child_key, new_val| [child_key, new_val] if new_val != old_value[child_key] }.compact.to_h
      elsif key != 'label'
        self[key] = old_value
        draft[key] = new_value
      end
    end

    self[:draft] = draft
  end

  def reify_draft!
    return unless draft.present?

    draft.each do |key, value|
      if key == 'extra'
        self[key].merge!(value)
      else
        self[key] = value
      end
    end
  end

  def discard_draft!
    self.draft = nil
  end

end
