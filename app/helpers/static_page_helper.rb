## STATIC PAGE HELPER
# Functions to support static pages

module StaticPageHelper

  ROLE_TO_URL = {
    home: :root,
    subtle_system: :subtle_system_nodes,
    articles: :categories,
    treatments: :treatments,
    tracks: :tracks,
    meditations: :meditations,
    streams: :streams,
  }.freeze

  # Fetch a preview of the static page for a given role
  def self.preview_for role
    # Simply fetch all previews and store them, because we know that every page load will require almost every static page preview to generate the navigation
    unless defined? @@static_page_previews
      @@static_page_previews = StaticPage.preload_for(:preview).special.index_by(&:role) # rubocop:disable Style/ClassVars
    end

    @@static_page_previews[role.to_s]
  end

  # Fetch a preview of the static page for a given role
  def static_page_preview_for role
    StaticPageHelper.preview_for(role)
  end

  # Many static pages represent special pages in the site.
  # This helper fetches the path for one of those special pages, or the default URL for a given role or static page.
  def static_page_path_for page_or_role
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    role = role&.to_sym

    if ROLE_TO_URL.key?(role)
      send(:"#{ROLE_TO_URL[role]}_#{Globalize.locale}_path")
    elsif role == :custom
      page_or_role.is_a?(StaticPage) ? static_page_path(page_or_role) : nil
    elsif role == nil
      ''
    else
      page = StaticPage.preload_for(:preview).find_by_role(role)
      polymorphic_path([page, Globalize.locale])
    end
  end

  # Many static pages represent special pages in the site.
  # This helper fetches the URL for one of those special pages, or the default URL for a given role or static page.
  def static_page_url_for page_or_role, locale: nil
    locale ||= Globalize.locale || I18n.locale
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    role = role&.to_sym

    if ROLE_TO_URL.key?(role)
      send(:"#{ROLE_TO_URL[role]}_#{locale}_url")
    elsif role == :custom
      page_or_role.is_a?(StaticPage) ? static_page_url(page_or_role) : nil
    elsif role == nil
      ''
    else
      page = StaticPage.preload_for(:preview).find_by_role(role)
      polymorphic_url([page, locale])
    end
  end

end
