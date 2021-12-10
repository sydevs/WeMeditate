require 'rubygems'
require 'google/cloud/storage'
require 'sitemap_generator'

# ===== CONFIGURATION ===== #
SitemapGenerator::Sitemap.sitemaps_host = ApplicationUploader.asset_host
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::GoogleStorageAdapter.new(
  bucket: ENV.fetch('GCLOUD_BUCKET')
)

host = 'https://www.wemeditate.com'.freeze
HOSTS = {} # rubocop:disable Style/MutableConstant
Rails.configuration.published_locales.each do |locale|
  HOSTS[locale] = host
end

EXCLUDE_STATIC_PAGES = %i[].freeze
SPECIAL_PAGES = {
  home: { url: :root_url, path: :root_path, changefreq: 'weekly' },
  subtle_system: { url: :subtle_system_nodes_url, path: :subtle_system_nodes_path, changefreq: 'weekly' },
  articles: { url: :categories_url, path: :categories_path, changefreq: 'weekly' },
  treatments: { url: :treatments_url, path: :treatments_path, changefreq: 'weekly' },
  tracks: { url: :tracks_url, path: :tracks_path, changefreq: 'weekly' },
  meditations: { url: :meditations_url, path: :meditations_path, changefreq: 'weekly' },
}.freeze

module SitemapHelper

  def record_data record
    {
      lastmod: record.updated_at,
      alternates: HOSTS.keys.map { |locale|
        I18n.with_locale(locale) do
          Rails.application.routes.default_url_options[:host] = HOSTS[locale]
          special_url = send(SPECIAL_PAGES[record.role&.to_sym][:url]) if record.is_a?(StaticPage) && SPECIAL_PAGES.key?(record.role&.to_sym)
          {
            href: special_url || polymorphic_public_url(record),
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

SitemapGenerator::Sitemap.create do
  SitemapGenerator::Sitemap.default_host = host
  Rails.application.routes.default_url_options[:host] = host

  StaticPage.published.preload_for(:content).where.not(role: EXCLUDE_STATIC_PAGES).each do |static_page|
    role = static_page.role&.to_sym

    if SPECIAL_PAGES.key? role
      add send(SPECIAL_PAGES[role][:path]), changefreq: SPECIAL_PAGES[role][:changefreq], **record_data(static_page)
    else
      add static_page_path(static_page), changefreq: 'weekly', **record_data(static_page)
    end
  end

  SubtleSystemNode.published.preload_for(:content).find_each do |subtle_system_node|
    add subtle_system_node_path(subtle_system_node), changefreq: 'weekly', **record_data(subtle_system_node)
  end

  Meditation.published.preload_for(:content).find_each do |meditation|
    add meditation_path(meditation), changefreq: 'weekly', **record_data(meditation)
  end

  Treatment.published.preload_for(:content).find_each do |treatment|
    add treatment_path(treatment), changefreq: 'weekly', **record_data(treatment)
  end

  Article.published.preload_for(:content).find_each do |article|
    add article_path(article), changefreq: 'weekly', **record_data(article)
  end

  Stream.published.preload_for(:content).find_each do |stream|
    add stream_path(stream), changefreq: 'weekly', **record_data(stream)
  end
end
