module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

  # The database names for the resource title is not consistent across all types of resources
  # TODO: Should probably just change the database names to be consistent
  def resource_name resource
    resource.respond_to?(:name) ? resource.name : resource.title
  end

end
