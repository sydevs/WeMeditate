
module Admin::RecordHelper

  ACTION_ICONS = {
    view: 'eye',
    edit: 'edit',
    destroy: 'trash',
  }.freeze

  # ===== MESSAGES ===== #
  def record_published_status
    published = @record.get_localized_attribute(:published)
    translate (published ? :is_published : :is_unpublished), scope: %i[admin details], page: @record.model_name.human.downcase
  end

  def record_published_at_status
    if !@record.published?
      translate 'admin.tags.unpublished_draft'
    elsif @record.draftable? && @record.has_draft? && @record.published_at.present?
      translate 'admin.tags.published_ago', time_ago: time_ago_in_words(@record.published_at)
    else
      translate 'admin.tags.published'
    end
  end

  def record_modified_at_status
    translate 'admin.tags.updated_ago', time_ago: time_ago_in_words(@record.updated_at)
  end

  # ===== INTERFACE ====== #

  def record_actions actions
    tag.div class: 'ui tiny compact basic buttons' do
      concat tag.div translate(actions.first, scope: %i[admin action]), class: 'ui button'
      concat record_actions_dropdown(actions.drop(1))
    end
  end

  def record_detail icon, value, label = nil, url: nil
    content_tag :div, class: 'item' do
      concat tag.i class: "#{icon} icon"
      concat record_detail_content(label, value, url)
    end
  end

  def block_comparison record, &block
    old_blocks = record.content_blocks
    new_blocks = record.draft_content_blocks
    old_block_ids = old_blocks.map { |block| block['data']['id'] }
    new_block_ids = new_blocks.map { |block| block['data']['id'] }
    diff = Diff::LCS.sdiff(old_block_ids, new_block_ids)

    current_index = 0

    diff.flatten.each do |change|
      old_block = old_blocks[change.old_position]
      new_block = new_blocks[change.new_position]

      case change.action
      when '+'
        moved = old_block_ids.include?(change.new_element)
        yield nil, new_block, 'added', (moved ? 'moved' : nil)
      when '-'
        moved = new_block_ids.include?(change.old_element)
        yield old_block, nil, 'removed', (moved ? 'moved' : nil)
      when '='
        if old_block == new_block
          yield old_block, nil, 'nochange'
        else
          yield old_block, new_block, 'modified'
        end
      end
    end
  end

  private

    def record_actions_dropdown actions
      tag.div class: 'ui floating dropdown icon button' do
        concat tag.i class: 'dropdown icon'
        concat record_actions_items(actions)
      end
    end

    def record_actions_items actions
      allow = policy(@record)

      tag.div class: 'menu' do
        actions.each do |action|
          concat record_actions_item(action) if allow.send("#{action}?")
        end
      end
    end

    def record_actions_item action
      args = { class: 'item' }
      args[:href] = polymorphic_admin_path(action == 'edit' ? [action, :admin, @record] : [:admin, @record])
      args[:method] = 'delete' if action == 'destroy'

      content_tag :a, **args do
        concat tag.i class: "#{ACTION_ICONS[action]} icon"
        concat translate(action, scope: %i[admin action])
      end
    end

    def record_detail_content label, value, url = nil
      content_tag (url ? :a : :div), class: 'content', href: url, target: '_blank' do
        concat tag.span value, class: 'text'
        concat tag.span label, class: 'label' if label
        concat tag.i class: 'grey external alternate icon' if url
      end
    end

end
