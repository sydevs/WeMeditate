## CONTENT HELPER
# This provides functions that help with rendering content blocks

module ContentHelper

  # Renders the content blocks for a record, by calling their appropriate partials.
  def render_content record, skip_splash: false
    return content_for(:content) if content_for?(:content)
    return unless record.parsed_content.present?

    record.content_blocks.each_with_index do |block, index|
      next if block['data']['type'] == 'splash' && skip_splash && index.zero?

      block_data = block['data'].deep_symbolize_keys

      if block_data[:legacy] || block['type'] == 'vimeo'
        block_partial = "legacy/#{block['type']}_block"
      elsif block_data[:type] == 'splash'
        block_partial = splash_partial
      elsif block['type'] == 'catalog' && (block_data[:style] != 'image' || block_data[:type] == 'articles')
        block_partial = 'catalog/generic_block'
      elsif block_data[:type]
        block_partial = "#{block['type']}/#{block['data']['type']}_block"
      else
        block_partial = "#{block['type']}_block"
      end

      concat render "content_blocks/#{block_partial}", block: block_data, record: record, index: index
    rescue ActionView::MissingTemplate => _e
      concat content_tag(:p, "Unsupported block #{block.inspect}")
    end

    nil
  end

  def render_splash_block record, overrides = {}
    return unless record.parsed_content.present?

    block = record.content_blocks.first['data'].deep_symbolize_keys
    overrides[:url] = overrides[:url] + block[:url] if overrides[:url] && block[:url]&.starts_with?('#')
    block.merge!(overrides)

    block_partial = splash_partial

    render "content_blocks/#{block_partial}", block: block, record: record, index: 0
  end

  def splash_partial
    file_name = controller_name == 'streams' ? 'streams' : @static_page&.role || @record&.slug
    puts "GET SPLASH PARTIAL #{file_name}"
    if File.exist?(Rails.root.join('app', 'views', 'content_blocks', 'custom_splash', "_#{file_name}.html.slim"))
      "custom_splash/#{file_name}"
    else
      'textbox/splash_block'
    end
  end

  # Render a decoration within a cotent block
  def render_decoration type, block, **args
    return unless block[:decorations].present? && block[:decorations][type].present?

    data = block[:decorations][type]
    classes = [type]
    classes << "#{type}--#{args[:alignment] || data[:alignment] || 'left'}" unless type == :circle
    classes << "gradient--#{data[:color] || 'orange'}" if type == :gradient

    if type == :gradient && args[:size]
      args[:size].each do |size|
        classes << "gradient--#{size}"
      end
    end

    if type == :circle
      inline_svg_tag 'graphics/circle.svg', class: classes
    elsif type == :sidetext
      classes << 'sidetext--overlay' unless args[:static]
      content_tag :div, data[:text], class: classes
    else
      tag.div class: classes
    end
  end

  # Basic formatting for a piece of text that might include line breaks
  def simple_format_content text
    simple_format(text.gsub('<br>', "\n").html_safe).gsub("\n", '').html_safe if text
  end

  # Display an error message only to administrators, to help debug issues with the content blocks
  def content_error message
    return unless current_user.present?

    content_tag :div, class: 'alert' do
      tag.div "Error: #{message}. Only administrators can see this error", class: 'alert__message'
    end
  end

end
