## NAVIGATON HELPER
# General helper methods that don't fit in the other files

module ApplicationHelper

  # Determine if we are currently viewing a CMS/Admin page, or the front end of the site.
  def admin?
    controller.class.name.split("::").first == 'Admin'
  end

  # Return the full url to a an image, instead of just the path. Useful for metadata
  def image_url source
    path_to_url image_path(source)
  end
  
  # Given an image page, convert it to the full image URL
  def path_to_url path
    "https://#{locale_host}/#{path.sub(/^\//, '')}"
  end

  # Get the web domain for the current locale
  def locale_host
    Rails.configuration.locale_hosts[Globalize.locale]
  end

end
