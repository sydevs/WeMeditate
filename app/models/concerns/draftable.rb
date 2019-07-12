## DRAFTABLE CONCERN
# This concern should be added to models that require an admin to approve any update,
# before it is reflected in the public-facing website.

module Draftable

  extend ActiveSupport::Concern

  included do |base|
    # Do nothing for now
  end

  def has_draft?
    draft.present?
  end

  def record_draft!
    draft = {}

    changes.each do |key, (old_value, new_value)|
      next if key == 'content' && JSON.parse(old_value)['blocks'] == JSON.parse(new_value)['blocks']
      self[key] = old_value
      draft[key] = new_value
    end

    self[:draft] = draft
  end

  def reify_draft!
    return unless draft.present?

    draft.each do |key, value|
      self[key] = value
    end
  end

  def discard_draft!
    self.draft = nil
  end

end
