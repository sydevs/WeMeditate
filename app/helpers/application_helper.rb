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
    "https://#{Rails.configuration.public_host}/#{path.sub(/^\//, '')}"
  end

  # Get the web url for the current locale
  def public_url
    locale = Globalize.locale || I18n.locale
    if locale == :en
      Rails.configuration.public_host
    else
      "#{Rails.configuration.public_host}/#{locale}"
    end
  end

end
