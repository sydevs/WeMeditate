## STATIC PAGE HELPER
# Functions to support static pages

module StaticPageHelper

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
    case role&.to_sym
    when :home
      root_path
    when :subtle_system
      subtle_system_nodes_path
    when :articles
      categories_path
    when :treatments
      treatments_path
    when :tracks
      tracks_path
    when :meditations
      meditations_path
    when :streams
      live_path
    when :custom
      page_or_role.is_a?(StaticPage) ? static_page_path(page_or_role) : nil
    when nil
      ''
    else
      static_page_path(static_page_preview_for(role))
    end
  end

  # Many static pages represent special pages in the site.
  # This helper fetches the URL for one of those special pages, or the default URL for a given role or static page.
  def static_page_url_for page_or_role
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    case role&.to_sym
    when :home
      root_url
    when :subtle_system
      subtle_system_nodes_url
    when :articles
      categories_url
    when :treatments
      treatments_url
    when :tracks
      tracks_url
    when :meditations
      meditations_url
    when :streams
      live_url
    when :custom
      page_or_role.is_a?(StaticPage) ? static_page_url(page_or_role) : nil
    when nil
      ''
    else
      static_page_url(static_page_preview_for(role))
    end
  end

end
