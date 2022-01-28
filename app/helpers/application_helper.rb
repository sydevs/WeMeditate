## NAVIGATON HELPER
# General helper methods that don't fit in the other files

module ApplicationHelper

  # Determine if we are currently viewing a CMS/Admin page, or the front end of the site.
  def admin?
    controller.class.name.split("::").first == 'Admin'
  end

  # Return the full url to a an image, instead of just the path. Useful for metadata
  def image_url source
    source.delete_prefix!('/')

    if source.starts_with?('uploads')
      path_to_url source
    elsif !source.starts_with?('http')
      path_to_url asset_pack_path("media/images/#{source}")
    else
      source
    end
  end
  
  # Given an image page, convert it to the full image URL
  def path_to_url path
    "https://#{Rails.configuration.public_host}/#{path.sub(%r{^\/}, '')}"
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

  def wm_url_for record, locale: nil
    locale ||= Globalize.locale || I18n.locale

    if record.is_a?(StaticPage)
      static_page_url_for(record, locale: locale.to_s)
    else
      polymorphic_url([record, locale])
    end
  end

end
