
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
    date = @record.has_draft? ? @record.updated_at : (@record.published_at || @record.updated_at)
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

  def record_detail icon, label, value, url = nil
    content_tag :div, class: 'item' do
      concat tag.i class: "#{icon} icon"
      concat record_detail_content(label, value, url)
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
