
# This helper provides methods to render information surrounding a single record.
module Admin::RecordHelper

  # Icons for certain actions that can be taken on a record
  ACTION_ICONS = {
    view: 'eye',
    edit: 'edit',
    destroy: 'trash',
  }.freeze

  # Some records cannot have their slug (aka URL) changed, this checks to see if the active record is one of those.
  def record_has_fixed_slug?
    case @record
    when StaticPage
      first_path_segment = static_page_path_for(@record).split('/').reject(&:empty?).first
      first_path_segment != translate('routes.page')
    when Meditation
      @record.slug == translate('routes.self_realization')
    else
      false
    end
  end

  # ===== INTERFACE ====== #

  # Render a set of actions, as a button with a dropdown
  def record_actions actions
    tag.div class: 'ui tiny compact basic buttons' do
      concat tag.div translate(actions.first, scope: %i[admin action]), class: 'ui button'
      concat record_actions_dropdown(actions.drop(1))
    end
  end

  # Render a small piece fo important content about a record
  def record_detail icon, value, label = nil, url: nil
    content_tag :div, class: 'item' do
      concat tag.i class: "#{icon} icon"
      concat record_detail_content(label, value, url)
    end
  end

  # Generates a comparison of changes between the live content blocks and draft content blocks for a given record
  # This is used to create the reviiew page.
  def block_comparison record, &_block
    old_blocks = record.content_blocks
    new_blocks = record.draft_content_blocks
    old_block_ids = old_blocks.map { |block| block['data']['id'] }
    new_block_ids = new_blocks.map { |block| block['data']['id'] }
    diff = Diff::LCS.sdiff(old_block_ids, new_block_ids)

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

    # Render a dropdown filled with actions
    def record_actions_dropdown actions
      tag.div class: 'ui floating dropdown icon button' do
        concat tag.i class: 'dropdown icon'
        concat record_actions_items(actions)
      end
    end

    # Render a set of actions within a dropdown
    def record_actions_items actions
      allow = policy(@record)

      tag.div class: 'menu' do
        actions.each do |action|
          concat record_actions_item(action) if allow.send("#{action}?")
        end
      end
    end

    # Render a single action within a dropdown
    def record_actions_item action
      args = { class: 'item' }
      args[:href] = polymorphic_admin_path(action == 'edit' ? [action, :admin, @record] : [:admin, @record])
      args[:method] = 'delete' if action == 'destroy'

      content_tag :a, **args do
        concat tag.i class: "#{ACTION_ICONS[action]} icon"
        concat translate(action, scope: %i[admin action])
      end
    end

    # Render the inner HTML of a small important detail about a given record
    def record_detail_content label, value, url = nil
      content_tag (url ? :a : :div), class: 'content', href: url, target: '_blank' do
        concat tag.span value, class: 'text'
        concat tag.span label, class: 'label' if label
        concat tag.i class: 'grey external alternate icon' if url
      end
    end

end
