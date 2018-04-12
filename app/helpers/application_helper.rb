module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

  def nav_link_for item
    case item
    when DurationFilter
      name = item.name
      url = meditations_path(duration: item.minutes)
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
