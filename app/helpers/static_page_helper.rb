## STATIC PAGE HELPER
# Functions to support static pages

module StaticPageHelper

  # Creates the markup for a sidetext element, if content for that element has been defined.
  def self.preview_for role
    if not defined? @@static_page_previews
      @@static_page_previews = StaticPage.preload_for(:preview).all.index_by(&:role)
    end

    @@static_page_previews[role.to_s]
  end

  def static_page_preview_for role
    StaticPageHelper.preview_for role
  end

  def static_page_path_for static_page
    case static_page.role.to_sym
    when :home
      root_path
    when :subtle_system
      subtle_system_nodes_path
    when :articles
      articles_path
    when :treatments
      treatments_path
    when :tracks
      tracks_path
    when :meditations
      meditations_path
    when :world, :country, :city
      # There is no single address for city and country pages, so just default to the world index
      cities_path
    else
      static_page_path(static_page)
    end
  end

end
