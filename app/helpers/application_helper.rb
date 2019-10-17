module ApplicationHelper

  def admin?
    controller.class.name.split("::").first == 'Admin'
  end

  def locale_host
    Rails.configuration.locale_hosts[I18n.locale]
  end

  def image_url source
    path_to_url image_path(source)
  end
    
  def path_to_url path
    "https://#{locale_host}/#{path.sub(/^\//, '')}"
  end

  def render_content record
    return content_for(:content) if content_for?(:content)
    return unless record.parsed_content.present?

    record.content_blocks.each do |block|
      concat render "content_blocks/#{block['type']}_block", block: block['data'].deep_symbolize_keys, record: record
    end

    return nil
  end

  def render_decoration type, block, **args
    return unless block[:decorations].present? && block[:decorations][type].present?

    data = block[:decorations][type]
    classes = [type]
    classes << "#{type}--#{args[:alignment] || data[:alignment] || 'left'}" unless type == :circle
    classes << "gradient--#{data[:color] || 'orange'}" if type == :gradient

    if type == :gradient && args[:size]
      for size in args[:size] do
        classes << "gradient--#{size}"
      end
    end

    if type == :circle
      inline_svg 'graphics/circle.svg', class: classes
    elsif type == :sidetext
      classes << 'sidetext--overlay' unless args[:static]
      content_tag :div, data[:text], class: classes
    else
      tag.div class: classes
    end
  end

  def simple_format_content text
    simple_format(text.gsub('<br>', "\n").html_safe).gsub("\n", '').html_safe
  end

  def error message
    content_tag :div, class: 'alert' do
      tag.div "Error: #{message}. Only administrators can see this error", class: 'alert__message'
    end
  end

end
