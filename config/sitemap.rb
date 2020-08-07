require 'rubygems'
require 'carrierwave'
require 'sitemap_generator'

# ===== CONFIGURATION ===== #
SitemapGenerator::Sitemap.default_host = 'https://www.wemeditate.co'
Rails.application.routes.default_url_options[:host] = 'https://www.wemeditate.co'
SitemapGenerator::Sitemap.sitemaps_host = ApplicationUploader.asset_host
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

HOSTS = Rails.configuration.locale_hosts.slice(*Rails.configuration.published_locales)
HOSTS.each { |key, host| HOSTS[key] = "https://#{host}" }
EXCLUDE_STATIC_PAGES = %i[].freeze
SPECIAL_PAGES = {
  home: { url: :root_url, changefreq: 'weekly' },
  subtle_system: { url: :subtle_system_nodes_url, changefreq: 'yearly' },
  articles: { url: :categories_url, changefreq: 'weekly' },
  treatments: { url: :treatments_url, changefreq: 'yearly' },
  tracks: { url: :tracks_url, changefreq: 'monthly' },
  meditations: { url: :meditations_url, changefreq: 'monthly' },
}.freeze

module SitemapHelper

  def record_data record
    {
      lastmod: record.updated_at,
      alternates: HOSTS.keys.map { |locale|
        I18n.with_locale(locale) do
          special_url = send(SPECIAL_PAGES[record.role&.to_sym][:url]) if record.is_a?(StaticPage) && SPECIAL_PAGES.key?(record.role&.to_sym)
          {
            href: special_url || polymorphic_url(record),
            lang: locale,
          }
        end
      },
      **(type_data(record) || {}),
    }
  end

  def type_data record
    images = []
    videos = []

    if record.is_a?(::Meditation)
      if record.horizontal_vimeo_id
        videos << {
          thumbnail_loc: record.image_url,
          player_loc: "https://vimeo.com/#{record.horizontal_vimeo_id}",
          title: record.name,
          description: record.excerpt,
          # duration: nil, # TODO: Add this
          view_count: record.views,
          publication_date: record.created_at,
          family_friendly: true,
        }
      end
    elsif record.is_a?(::Treatment)
      if record.horizontal_vimeo_id
        videos << {
          thumbnail_loc: record.thumbnail.url,
          player_loc: "https://vimeo.com/#{record.horizontal_vimeo_id}",
          title: record.name,
          description: record.excerpt,
          # duration: nil, # TODO: Add this
          family_friendly: true,
        }
      else
        images << {
          log: record.thumbnail.url,
          title: record.name,
          description: record.excerpt,
        }
      end
    end

    if record.contentable?
      record.content_blocks.each do |block|
        case block['type']
        when 'textbox'
          images << {
            loc: record.media_file(block['data']['image']['id'])&.url,
            title: block['data']['title'],
          }
        when 'image', 'structured'
          block['data']['items'].each do |item|
            next unless item['image'].present?
            images << {
              loc: record.media_file(item['image']['id']).url,
              title: item['alt'],
              caption: item['caption'],
            }
          end
        when 'video'
          block['data']['items'].each do |item|
            next unless item['vimeo_id'].present? && item['thumbnail'].present?
            videos << {
              thumbnail_loc: item['thumbnail'],
              player_loc: "https://vimeo.com/#{item['vimeo_id']}",
              title: item['title'],
              family_friendly: true,
            }
          end
        end
      end
    end

    data = {}
    data[:images] = images
    data[:video] = videos.first if videos.length == 1
    data[:videos] = videos if videos.length > 1
    data
  end

end

SitemapGenerator::Interpreter.send :include, SitemapHelper

HOSTS.each do |locale, host|
  I18n.locale = locale
  SitemapGenerator::Sitemap.default_host = host
  SitemapGenerator::Sitemap.filename = "sitemap.#{locale}"
  SitemapGenerator::Sitemap.create do
    StaticPage.published.preload_for(:content).where.not(role: EXCLUDE_STATIC_PAGES).each do |static_page|
      role = static_page.role&.to_sym

      if SPECIAL_PAGES.key? role
        add send(SPECIAL_PAGES[role][:url]), changefreq: SPECIAL_PAGES[role][:changefreq], **record_data(static_page)
      else
        add static_page_url(static_page), changefreq: 'yearly', **record_data(static_page)
      end
    end

    SubtleSystemNode.published.preload_for(:content).find_each do |subtle_system_node|
      add subtle_system_node_url(subtle_system_node), changefreq: 'yearly', **record_data(subtle_system_node)
    end

    Meditation.published.preload_for(:content).find_each do |meditation|
      add meditation_url(meditation), changefreq: 'yearly', **record_data(meditation)
    end

    Treatment.published.preload_for(:content).find_each do |treatment|
      add treatment_url(treatment), changefreq: 'yearly', **record_data(treatment)
    end

    Article.published.preload_for(:content).find_each do |article|
      add article_url(article), changefreq: 'yearly', **record_data(article)
    end
  end
end
