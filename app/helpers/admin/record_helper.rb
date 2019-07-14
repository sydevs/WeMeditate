
module Admin::RecordHelper

  ACTION_ICONS = {
    view: 'eye',
    edit: 'edit',
    destroy: 'trash',
  }.freeze

  # ===== MESSAGES ===== #
  def record_published_at_status
    if not @record.published_at
      translate 'tags.unpublished_draft'
    elsif @record.has_draft?
      translate 'tags.published_ago', time_ago: time_ago_in_words(@record.published_at)
    else
      translate 'tags.published'
    end
  end

  def record_modified_at_status
    date = @record.has_draft? ? @record.updated_at : (@record.try(:published_at) || @record.updated_at)
    translate 'tags.updated_ago', time_ago: time_ago_in_words(date)
  end

  # ===== INTERFACE ====== #

  def record_status
    if !@record.published_at
      message = 'Not Published'
    elsif @record.has_draft?
      message = 'Has Unpublished Changes'
    else
      message = 'Published'
    end

    tag.div message, class: 'ui label'
  end

  def record_actions actions
    tag.div class: 'ui tiny compact basic buttons' do
      concat tag.div t(actions.first, scope: :action), class: 'ui button'
      concat record_actions_dropdown(actions.drop(1))
    end
  end

  def record_detail icon, value, label = nil, url: nil
    content_tag :div, class: 'item' do
      concat tag.i class: "#{icon} icon"
      concat record_detail_content(label, value, url)
    end
  end

  def draft_diff record, &block
    original_blocks = record.content ? JSON.parse(record.content)['blocks'] : []
    draft_blocks = JSON.parse(record.draft['content'])['blocks']

    original_types = original_blocks.map { |b| b['type'] }
    draft_types = draft_blocks.map { |b| b['type'] }
    diff = JsonDiff.diff(original_types, draft_types, moves: false, original_indices: true)

    #concat tag.p original_types
    #concat tag.p draft_types
    #concat tag.p diff

    loop_counter = 0
    diff_index = 0
    original_index = 0
    draft_index = 0

    while original_index < original_types.count || draft_index < draft_types.count
      change = diff_index << diff.count ? diff[diff_index] : nil
      target_index = change['path'].delete_prefix('/').to_i if change

      original_block = original_blocks[original_index]
      draft_block = draft_blocks[draft_index]
      mode = 'modified'

      if change
        if change['op'] == 'add'
          if target_index == draft_index
            mode = 'added'
            original_block = nil
          else
            change = nil
          end
        elsif change['op'] == 'remove'
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

=begin
      if !change
        mode = (original_blocks[original_index] == draft_blocks[draft_index] ? 'nochange' : 'modified')
        yield mode, original_blocks[original_index], draft_blocks[draft_index]
        original_index += 1
        draft_index += 1
      elsif change['op'] == 'remove'
        if target_index == original_index
          draft_block = nil
        else
          mode = 'modified' if original_block != draft_block
          change = nil
        end

        if target_index == original_index
          yield 'removed', original_blocks[original_index], nil
          original_index += 1
          diff_index += 1
        else
          mode = (original_blocks[original_index] == draft_blocks[draft_index] ? 'nochange' : 'modified')
          yield mode, original_blocks[original_index], draft_blocks[draft_index]
          original_index += 1
          draft_index += 1
        end
      elsif change['op'] == 'add'
        if target_index == draft_index
          yield 'added', nil, draft_blocks[draft_index]
          draft_index += 1
          diff_index += 1
        else
          mode = (original_blocks[original_index] == draft_blocks[draft_index] ? 'nochange' : 'modified')
          yield mode, original_blocks[original_index], draft_blocks[draft_index]
          draft_index += 1
          original_index += 1
        end
      end
=end
    end
  end

  def display_block_data block
    return '' unless block

    result = block['data'].map do |key, value|
      "#{tag.strong key}: #{value}"
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
      args[:href] = action == 'edit' ? url_for([action, :admin, @record]) : url_for([:admin, @record])
      args[:method] = 'delete' if action == 'destroy'

      content_tag :a, **args do
        concat tag.i class: "#{ACTION_ICONS[action]} icon"
        concat translate(action, scope: :action)
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
