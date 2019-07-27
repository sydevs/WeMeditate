## DRAFTABLE CONCERN
# This concern should be added to models that require an admin to approve any update,
# before it is reflected in the public-facing website.

module Draftable

  extend ActiveSupport::Concern

  included do |base|
    # Do nothing for now
  end

  def local_draft
    @local_draft = get_localized_attribute(:draft)
  end

  def parsed_draft_content
    @parsed_draft_content = local_draft['content'].present? ? JSON.parse(local_draft['content']) : nil
  end

  def has_draft? attribute = nil
    local_draft.present? && (attribute.nil? || local_draft.has_key?(attribute.to_s))
  end

  def record_draft! user
    new_draft = {}
    new_draft['contributors'] = has_draft? ? local_draft['contributors'] : []
    new_draft['contributors'] = new_draft['contributors'].to_set.add(user.id).to_a

    changes.each do |key, (old_value, new_value)|
      next if key == 'published_at' # We should not include timestamps in drafts

      if key == 'content'
        old_val = JSON.parse(old_value)['blocks'] if old_value
        new_val = JSON.parse(new_value)['blocks'] if new_value
        next if old_val == new_val
      end

      if old_value.to_s != new_value.to_s
        self[key] = old_value
        new_draft[key] = new_value
      else
        new_draft.except!(key)
      end
    end

    self[:draft] = (local_draft || {}).merge(new_draft)
  end

  def reify_draft!
    return unless local_draft.present?

    local_draft.each do |key, value|
      self[key] = value
    end
  end

  def reify_approved_changes! attributes
    if attributes.present?
      attributes.each do |key, data|
        if key == 'content'
          approve_content!(data)
        else
          self[key] = local_draft[key]
        end
      end
    end

    discard_draft!
  end

  def cleanup_draft!
    draft = local_draft

    changes.each do |key, (old_value, new_value)|
      next unless draft.has_key?(key)

      if key == 'content'
        # Compare content using the blocks only.
        new_value = JSON.parse(new_value)['blocks'] if new_value
        draft_value = parsed_draft_content['blocks'] if parsed_draft_content
      else
        draft_value = draft[key]
      end

      draft.except!(key) if new_value == draft_value
    end

    draft = nil unless draft.except('contributors').present?
    write_attribute :draft, draft
  end

  def discard_draft!
    self.draft = nil
  end

  private

    def approve_content! data
      original_blocks = content_blocks
      draft_content = parsed_draft_content
      blocks = []

      data.each do |index, dat|
        dat1 = dat.split(':')
        mode = dat1[0]
        index = dat1[1].to_i

        if mode == 'keep'
          blocks << original_blocks[index]
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
