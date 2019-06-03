module Admin::SectionHelper

  SECTION_FIELDS_MAP = {
    text: {
      default: %i[],
      just_text: %i[title rich_text],
      just_quote: %i[subtitle text credit action url],
      with_image: %i[title rich_text image credit],
      with_quote: %i[title rich_text quote],
    },
    image: {
      default: %i[],
      fit_container_width: %i[title subtitle image credit],
      fit_page_width: %i[title subtitle image credit],
      image_gallery: %i[images],
    },
    video: {
      default: %i[decorations decorations_sidetext],
      single: %i[video],
      video_gallery: %i[videos],
    },
    action: {
      default: %i[action],
      signup: %i[title subtitle text],
      button: %i[url decorations decorations_leaf decorations_circle],
    },
    textbox: {
      default: %i[title image decorations decorations_sidetext decorations_triangle decorations_circle decorations_gradient],
      lefthand: %i[text],
      righthand: %i[text],
      overtop: %i[text color],
      ancient_wisdom: %i[rich_text],
    },
    structured: {
      default: %i[decorations decorations_sidetext],
      columns: %i[columns],
      grid: %i[title text grid],
    },
  }.freeze

  def section_extra_value section, attribute
    section.extra_attr(attribute.to_s)
  end

  def section_extra_draft_value section, attribute
    has_draft = section.draft.present? and section.draft['extra'].present? and section.draft['extra'].key?(attribute.to_s)
    section.draft['extra'][attribute.to_s] if has_draft
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
        format_fields_map[:default].each do |fromat_field|
          result[fromat_field] ||= ['for']
          formats.each do |format|
            result[fromat_field] << "#{content_type}-#{format}"
          end
        end

        formats.each do |format|
          format_fields_map[format].each do |fromat_field|
            result[fromat_field] ||= ['for']
            result[fromat_field] << "#{content_type}-#{format}"
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
      I18n.translate "activerecord.attributes.section.decoration_options.#{option}"
    end
  end

end
