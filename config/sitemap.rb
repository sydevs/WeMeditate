# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add meditations, changefreq: 'monthly'
  add articles_path, changefreq: 'weekly'
  add tracks_path, changefreq: 'monthly'

  StaticPage.where.not(role: [:country, :city]).each do |static_page|
    case static_page.role.to_sym
    when :home
      add root_path, changefreq: 'weekly', lastmod: static_page.updated_at
    when :subtle_system
      add subtle_system_nodes_path, changefreq: 'yearly', lastmod: static_page.updated_at
    when :articles
      add articles_path, changefreq: 'weekly', lastmod: static_page.updated_at
    when :treatments
      add treatments_path, changefreq: 'yearly', lastmod: static_page.updated_at
    when :tracks
      add tracks_path, changefreq: 'monthly', lastmod: static_page.updated_at
    when :meditations
      add meditations_path, changefreq: 'monthly', lastmod: static_page.updated_at
    when :world
      add cities_path, changefreq: 'monthly', lastmod: static_page.updated_at
    else
      add static_page_path(static_page), changefreq: 'yearly', lastmod: static_page.updated_at
    end
  end

  SubtleSystemNode.all.each do |subtle_system_node|
    add subtle_system_node_path(subtle_system_node), lastmod: subtle_system_node.updated_at, changefreq: 'yearly'
  end

  Meditation.find_each do |meditation|
    add meditation_path(meditation), lastmod: meditation.updated_at, changefreq: 'yearly'
  end

  Treatment.find_each do |treatment|
    add treatment_path(treatment), lastmod: treatment.updated_at, changefreq: 'yearly'
  end

  Article.find_each do |article|
    add article_path(article), lastmod: article.updated_at, changefreq: 'yearly'
  end

  City.find_each do |city|
    add city_path(city), lastmod: city.updated_at, changefreq: 'monthly'
  end

  City.distinct.pluck(:country).each do |country_code|
    add country_cities_path(country_code: country_code), changefreq: 'monthly'
  end
end
