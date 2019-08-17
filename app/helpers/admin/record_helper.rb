
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
    elsif @record.reviewable? && @record.has_draft?
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
    original_blocks = record.content_blocks
    draft_blocks = record.draft_content_blocks
    original_block_ids = original_blocks.map { |block| block['data']['id'] }
    draft_block_ids = draft_blocks.map { |block| block['data']['id'] }
    original_index = 0
    draft_index = 0

    while original_index < original_block_ids.count || draft_index < draft_block_ids.count
      original_id = original_block_ids[original_index]
      draft_id = draft_block_ids[draft_index]
      original_block = original_blocks[original_index]
      draft_block = draft_blocks[draft_index]

      if original_id == draft_id
        if original_block == draft_block
          yield original_block, nil, 'nochange'
        else
          yield original_block, draft_block, 'modified'
        end

        original_index += 1
        draft_index += 1
      else
        yield original_block, nil, 'removed' unless original_block.nil?
        yield nil, draft_block, 'added' unless draft_block.nil?
        original_index += 1
        draft_index += 1
      end
    end
  end

  def draft_diff record, &block
    original_blocks = record.content_blocks
    draft_blocks = record.parsed_draft_content['blocks']

    original_types = original_blocks.map { |b| b['type'] }
    draft_types = draft_blocks.map { |b| b['type'] }
    diff = Hashdiff.diff(original_types, draft_types, array_path: true)

    # TODO: Remove test code
    puts "DRAFT DIFF"
    puts original_types.pretty_inspect
    puts draft_types.pretty_inspect
    puts diff.pretty_inspect
    puts "----"

    loop_counter = 0
    diff_index = 0
    original_index = 0
    draft_index = 0

    while original_index < original_types.count || draft_index < draft_types.count
      change = diff_index << diff.count ? diff[diff_index] : nil
      target_index = change[1][0] if change

      original_block = original_blocks[original_index]
      draft_block = draft_blocks[draft_index]
      mode = 'modified'

      if change
        if change[0] == '+'
          if target_index == draft_index
            mode = 'added'
            original_block = nil
          else
            change = nil
          end
        elsif change[0] == '-'
          if target_index == draft_index
            mode = 'removed'
            draft_block = nil
          else
            change = nil
          end
        end
      end

      mode = 'nochange' if mode == 'modified' && original_block == draft_block
      yield(loop_counter, mode, original_block, draft_block, (original_index if original_block), (draft_index if draft_block))
      diff_index += 1 if change
      original_index += 1 if original_block
      draft_index += 1 if draft_block
      loop_counter += 1
    end
  end

  def display_block_data block
    return '' unless block

    result = block['data'].map do |key, value|
      "#{key}: #{value}"
    end
    result.join("<br>").to_s
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
