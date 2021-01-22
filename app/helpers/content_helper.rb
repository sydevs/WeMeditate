## CONTENT HELPER
# This provides functions that help with rendering content blocks

module ContentHelper

  # Renders the content blocks for a record, by calling their appropriate partials.
  def render_content record, skip_splash: false
    return content_for(:content) if content_for?(:content)
    return unless record.parsed_content.present?

    toc_position = record.try(:table_of_contents_position) || 0 if record.try(:table_of_contents?)
    record.content_blocks.each_with_index do |block, index|
      next if block['type'] == 'splash' && skip_splash

      concat render_table_of_contents(record) if !toc_position.nil? && index == toc_position
      concat render "content_blocks/#{block['type']}_block", block: block['data'].deep_symbolize_keys, record: record
    end

    return nil
  end

  def render_table_of_contents record
    content_tag(:div, class: 'contents') do
      content_tag(:div, class: 'contents__list') do
        record.content_blocks.each do |block|
          next unless block['type'] == 'header'
          
          concat content_tag(:a, block['data']['text'], {
            class: "contents__item contents__item--#{block['data']['level'][1].to_i - 1}",
            href: "##{block['data']['text'].parameterize}",
          })
        end
      end
    end
  end

  def render_splash_block record, overrides = {}
    return unless record.parsed_content.present?

    block = record.content_blocks.first['data'].deep_symbolize_keys
    overrides[:url] = overrides[:url] + block[:url] if overrides[:url] && block[:url]&.starts_with?('#')
    block.merge!(overrides)

    render 'content_blocks/splash_block', block: block, record: record
  end

  # Render a decoration within a cotent block
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
