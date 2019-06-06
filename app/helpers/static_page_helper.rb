## STATIC PAGE HELPER
# Functions to support static pages

module StaticPageHelper

  # Creates the markup for a sidetext element, if content for that element has been defined.
  def self.preview_for role
    unless defined? @@static_page_previews
      @@static_page_previews = StaticPage.preload_for(:preview).all.index_by(&:role) # rubocop:disable Style/ClassVars
    end

    @@static_page_previews[role.to_s]
  end

  def static_page_preview_for role
    StaticPageHelper.preview_for role
  end

  def static_page_path_for page_or_role
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    case role.to_sym
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
    else
      static_page_path(static_page_preview_for(role))
    end
  end

  def static_page_url_for page_or_role
    role = page_or_role.is_a?(StaticPage) ? page_or_role.role : page_or_role
    case role.to_sym
    when :home
      root_url
    when :subtle_system
      subtle_system_nodes_url
    when :articles
      articles_url
    when :treatments
      treatments_url
    when :tracks
      tracks_url
    when :meditations
      meditations_path
    else
      static_page_url(static_page_preview_for(role))
    end
  end

end
