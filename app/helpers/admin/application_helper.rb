
module Admin::ApplicationHelper

  # Admin URLs require a bit of special handling, to support all the abstraction that we do in the CMS
  def polymorphic_admin_path args, options = {}
    unless args.last.is_a?(Class)
      options[:id] = args.last.id
      options[:format] ||= nil
    end

    options[:locale] = Globalize.locale
    polymorphic_path(args, **options)
  end

  # Provides an easy link to view a set of coordinates on Google
  def coordinates_url latitude, longitude
    "https://www.google.com/maps/search/?api=1&query=#{latitude}%2C#{longitude}"
  end

  # Creates a mailto link for reporting any issues with the CMS
  def report_url
    report_url = "mailto:\"#{translate 'admin.report_issue.name'}\"<#{translate 'admin.report_issue.email'}>"
    report_url += "?subject=#{CGI.escape translate('admin.report_issue.subject')}"
    report_url += "&body=#{CGI.escape translate('admin.report_issue.body')}"
    report_url
  end

  def label_tag icon, text
    tag.div class: 'ui icon label' do
      concat tag.i class: "#{icon} icon"
      concat ' '
      concat text
    end
  end

  # This is a more complex method which generates a summary of the content blocks for a given page.
  # Just to give an overview of the page content to a user, instead of showing them the whole content.
  def content_outline record
    blocks = record.content_blocks if record.parsed_content.present?
    return unless blocks

    content_tag :ul, class: 'content-outline' do
      # Loop through each block in the record, and generate a short piece of text describing that block.
      for block in blocks
        case block['type']
        when 'paragraph'
          text = block['data']['text']
          if block['data']['type'] == 'header'
            result = tag.strong(text)
          else
            result = block['data']['text'].truncate(200)
          end

        when 'list'
          result = block['data']['items'].map { |i| "— #{i}".truncate(60) }.join('<br>')
          result = sanitize(result, tags: %w[br])

        when 'layout'
          result = block['data']['items'].map { |i| "— #{i['title']}" }.join('<br>')
          result = sanitize(result, tags: %w[br])

        when 'catalog'
          result = translate("activerecord.models.#{block['data']['type'].singularize}.other")
          result += ": #{translate('admin.content.items', count: block['data']['items'].length)}"

        when 'textbox'
          result = "<strong>#{block['data']['title']}</strong><br>#{block['data']['text'].truncate(60)}<br>"
          result += tag.span("[#{block['data']['action']}] → ") + tag.small(block['data']['url']) if block['data']['action'] && block['data']['url']
          result = sanitize(result, tags: %w[strong br])

        when 'action'
          result = tag.span("[#{block['data']['action']}] → ") + tag.small(block['data']['url']) if block['data']['action'] && block['data']['url']

        when 'media'
          result = block['data']['items'].map { |i| "#{tag.i(class: "#{block['data']['type']} icon")} <a href=\"#{i['image']['preview']}\" target=\"_blank\">#{i['image']['preview'].split('/').last}</a>#{" - \"#{i['caption'].truncate(100)}\"" if i['caption']}" }.join('<br>')
          result = sanitize(result, tags: %w[i a br])

        when 'vimeo'
          result = block['data']['items'].map { |i| "#{tag.i(class: 'video icon')} #{i['title']}" }.join('<br>')
          result = sanitize(result, tags: %w[i a br])

        when 'whitespace'
          separators = {
            large: '==',
            medium: '—',
            small: '--',
          }

          result = separators[block['data']['size'].to_sym] * 3

        else
          concat block.inspect
        end

        concat content_tag :li, result, class: "content-outline__#{block['type']} content-outline__#{block['type']}--#{block['data']['type']}"
      end
    end
  end

end
