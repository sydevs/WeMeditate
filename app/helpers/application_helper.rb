module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

  def duration_filter_name duration_filter
    time_ago_in_words(duration_filter.minutes.minutes.from_now).titleize
  end

  def markdown content
    @rc ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, no_intra_emphasis: true, autolink: true, space_after_headers: true)
    @rc.render(content).html_safe
  end

  def nav_link_for item
    case item
    when DurationFilter
      name = duration_filter_name(item)
      url = meditations_url(duration: item.minutes)
    else
      name = resource_name(item)
      url = url_for(item)
    end

    content_tag :a, name, href: url
  end

  def resource_name resource
    resource.respond_to?(:name) ? resource.name : resource.title
  end

end
