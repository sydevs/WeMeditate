module Admin::SectionHelper

  SECTION_FIELDS_MAP = {
    text: {
      default: [],
      just_text: [:title, :rich_text],
      just_quote: [:subtitle, :text, :credit, :action, :url],
      with_image: [:title, :rich_text, :image, :credit],
      with_quote: [:title, :rich_text, :quote],
    },
    image: {
      default: [],
      fit_container_width: [:image, :credit],
      fit_page_width: [:image, :credit],
      image_gallery: [:images],
    },
    video: {
      default: [:decorations, :decorations_sidetext],
      single: [:video],
      video_gallery: [:videos],
    },
    action: {
      default: [:action],
      signup: [:title, :subtitle, :text],
      button: [:url, :decorations, :decorations_leaf, :decorations_circle],
    },
    textbox: {
      default: [:title, :image, :decorations, :decorations_sidetext, :decorations_triangle, :decorations_circle, :decorations_gradient],
      lefthand: [:text],
      righthand: [:text],
      overtop: [:text, :color],
      ancient_wisdom: [:rich_text],
    },
    structured: {
      default: [:decorations, :decorations_sidetext],
      columns: [:columns],
      grid: [:title, :text, :grid],
    },
  }

  def section_extra_value section, attribute
    section.extra_attr(attribute.to_s)
  end

  def section_extra_draft_value section, attribute
    if section.draft.present? and section.draft['extra'].present? and section.draft['extra'].key?(attribute.to_s)
      section.draft['extra'][attribute.to_s]
    else
      nil
    end
  end

  def format_options record
    result = []

    Section::FORMATS.each do |content_type, formats|
      formats.each do |format|
        result << [human_enum_name(record, :format, format), format, { class: "for-#{content_type}" }]
      end
    end

    result
  end

  def field_classes field
    @field_classes ||= begin
      result = {}

      SECTION_FIELDS_MAP.each do |content_type, format_fields_map|
        formats = format_fields_map.keys - [:default]
        format_fields_map[:default].each do |field|
          result[field] ||= ['for']
          formats.each do |format|
            result[field] << "#{content_type}-#{format}"
          end
        end

        formats.each do |format|
          format_fields_map[format].each do |field|
            result[field] ||= ['for']
            result[field] << "#{content_type}-#{format}"
          end
        end
      end

      result
    end

    @field_classes[field].join(' ')
  end

  def decoration_type_label type
    I18n.translate "activerecord.attributes.section.decoration_types.#{type}"
  end

  def decoration_option_label option, value = nil
    if value
      I18n.translate "activerecord.attributes.section.decoration_options.#{option.to_s.pluralize}.#{value}"
    else
      I18n.translate "activerecord.attributes.section.decoration_options.#{option.to_s}"
    end
  end
end
