module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

  # TODO: This function no longer appears to be in use. Delete it if no issues show up within a few days of work.
  '''
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
  '''

  # The database names for the resource title is not consistent across all types of resources
  # TODO: Should probably just change the database names to be consistent
  def resource_name resource
    resource.respond_to?(:name) ? resource.name : resource.title
  end

end
