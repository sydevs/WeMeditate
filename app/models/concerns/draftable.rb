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
    draft ||= {}

    changes.each do |key, (old_value, new_value)|
      next if key == 'content' && (JSON.parse(old_value)['blocks'] == JSON.parse(new_value)['blocks'])
      next if key == 'published_at' # We should not include timestamps in drafts

      if old_value.to_s != new_value.to_s
        self[key] = old_value
        draft[key] = new_value
      else
        draft.except!(key)
      end
    end

    self[:draft] = draft
  end

  def reify_draft!
    return unless draft.present?

    draft.each do |key, value|
      self[key] = value
    end
  end

  def reify_approved_changes! attributes
    if attributes.present?
      attributes.each do |key, data|
        if key == 'content'
          approve_content!(data)
        else
          self[key] = draft[key]
        end
      end
    end

    discard_draft!
  end

  def discard_draft!
    self.draft = nil
  end

  private

    def approve_content! data
      original_content = JSON.parse(content)
      draft_content = JSON.parse(draft['content'])
      blocks = []

      data.each do |index, dat|
        dat1 = dat.split(':')
        mode = dat1[0]
        index = dat1[1].to_i

        if mode == 'keep'
          blocks << original_content['blocks'][index]
        elsif mode == 'use'
          blocks << draft_content['blocks'][index]
        else
          throw ArgumentError, dat
        end
      end

      draft_content['blocks'] = blocks
      self.content = draft_content
    end

end
