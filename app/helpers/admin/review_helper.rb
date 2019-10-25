
# This class provides helpers for the review page
module Admin::ReviewHelper

  # These are the fields that will trigger a review for the "Excerpt" preview
  REFRESH_EXCERPT_FIELDS = {
    article: %w[name thumbnail_id excerpt vimeo_id date],
    subtle_system_node: %w[name excerpt],
    treatment: %w[name thumbnail_id excerpt],
  }

  # Render an item for the left-hand review menu.
  def review_menu_item id, context, record: nil, label: nil, effect: 'modified', effect_label: nil
    model_key = record&.model_name&.singular_route_key&.to_sym
    refresh = REFRESH_EXCERPT_FIELDS.include?(model_key) && REFRESH_EXCERPT_FIELDS[model_key].include?(id)

    if record.present?
      new_value = record.parsed_draft[id]
      old_value = record.send(id)
      if new_value == old_value
        effect = 'nochange'
      elsif !new_value.present?
        effect = 'removed'
      elsif !old_value.present?
        effect = 'added'
      end
    end

    disabled = (effect == 'nochange')

    content_tag :a, class: "review item review-button #{disabled ? 'disabled' : 'approved'}", data: { id: id, context: context, effect: effect, refresh: refresh } do
      label = human_attribute_name(record, id) unless label.present?
      label = "#{translate(effect_label || effect, scope: %i[admin review effect])} #{label}" unless effect == 'nochange'
      concat tag.div label, class: 'content'

      concat tag.div "<i class=\"check icon\"></i>#{'Approve'}".html_safe, class: 'approve'
      concat tag.div "<i class=\"close icon\"></i>#{'Reject'}".html_safe, class: 'reject'
      concat tag.div "<i class=\"minus icon\"></i>#{'No Change'}".html_safe, class: 'disabled'
    end
  end

  # Render a block representing the state of some attribute of the given record
  def detail_review_block record, attribute, icon: nil, type: :string
    content_tag :div, class: 'approved item review-block', data: { id: attribute } do
      concat tag.i class: "#{icon} icon"
      concat detail_review_block_content(record, attribute, type)
    end
  end

  private

    # Inner content for a "detail" review block
    def detail_review_block_content record, attribute, type
      content_tag :div, class: 'content' do
        concat tag.div human_attribute_name(record.class, attribute), class: 'header'
        concat detail_review_block_description(record, attribute, type)
      end
    end

    # Description for a "detail" review block
    def detail_review_block_description record, attribute, type
      content_tag :div, class: 'description' do
        concat tag.div review_readable_value(@record, attribute, type), class: 'review-block-original'
        concat tag.div review_readable_value(@record, attribute, type, draft: true), class: 'review-block-draft'
      end
    end

    # A human readable value of a change in the record
    def review_readable_value record, attribute, type, draft: false
      value = draft && record.parsed_draft.include?(attribute) ? record.parsed_draft[attribute] : record.send(attribute)

      # Different types of attributes need to be rendered differently.
      case type
      when :association
        if value
          model = attribute.delete_suffix('_id').classify.constantize
          value = model.find_by(id: value)
          value ? value.preview_name : translate('admin.review.invalid_value')
        else
          translate('admin.review.no_value')
        end
      when :enum
        human_enum_name(record, attribute, value)
      when :date
        value.present? ? localize(Date.parse(value.to_s), format: :long).to_s : translate('admin.review.no_value')
      when :boolean
        ActiveModel::Type::Boolean.new.cast(value) ? 'Yes' : 'No' 
      when :json
        value ? value.map { |key, value| "#{key} => #{value}" }&.join("\r\n") : translate('admin.review.no_value')
      else
        value.present? ? value : translate('admin.review.no_value')
      end
    end

end
