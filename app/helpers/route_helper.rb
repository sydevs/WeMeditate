## ROUTE HELPER
# Functions to support custom routing

module RouteHelper

  STATIC_PAGE_ROLE_TO_URL = {
    home: :root,
    subtle_system: :subtle_system_nodes,
    articles: :categories,
    treatments: :treatments,
    tracks: :tracks,
    meditations: :meditations,
    streams: :streams,
  }.freeze

  # Many static pages represent special pages in the site.
  # This helper fetches the path for one of those special pages, or the default URL for a given role or static page.
  def static_page_path page_or_role
    locale = Globalize.locale || I18n.locale
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    route = STATIC_PAGE_ROLE_TO_URL[role&.to_sym] || role
    send(:"#{route}_#{locale}_path")
  end

  # Many static pages represent special pages in the site.
  # This helper fetches the URL for one of those special pages, or the default URL for a given role or static page.
  def static_page_url page_or_role, locale: nil
    locale ||= Globalize.locale || I18n.locale
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    route = STATIC_PAGE_ROLE_TO_URL[role&.to_sym] || role
    send(:"#{route}_#{locale}_url")
  end

  # Given a path, convert it to the full URL
  def path_to_url path
    "https://#{Rails.configuration.public_host}/#{path.sub(%r{^\/}, '')}"
  end

  # Get the web url for the current locale
  def public_url
    locale = Globalize.locale || I18n.locale
    
    if locale == :en
      "https://#{Rails.configuration.public_host}"
    else
      "https://#{Rails.configuration.public_host}/#{locale}"
    end
  end

  def wm_path_for record
    locale ||= Globalize.locale || I18n.locale

    if record.is_a?(StaticPage)
      static_page_path(record)
    else
      polymorphic_path([record, locale])
    end
  end

  def wm_url_for record, locale: nil
    locale ||= Globalize.locale || I18n.locale

    if record.is_a?(StaticPage)
      static_page_url(record, locale: locale.to_s)
    else
      polymorphic_url([record, locale])
    end
  end

end
