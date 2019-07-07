require 'rubygems'
require 'sitemap_generator'

# SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/sitemap-generator/"
# SitemapGenerator::Sitemap.public_path = 'tmp/'
# SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
# SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

# TODO: Rewrite this for the new content system

=begin
HOSTS = {
  en: 'https://wemeditate.co',
  ru: 'https://wemeditate.ru',
  de: 'https://wemeditate.co',
}.freeze

EXCLUDE_STATIC_PAGES = %i[].freeze
SPECIAL_PAGES = {
  home: { url: :root_path, changefreq: 'weekly' },
  subtle_system: { url: :subtle_system_nodes_path, changefreq: 'yearly' },
  articles: { url: :categories_path, changefreq: 'weekly' },
  treatments: { url: :treatments_path, changefreq: 'yearly' },
  tracks: { url: :tracks_path, changefreq: 'monthly' },
  meditations: { url: :meditations_path, changefreq: 'monthly' },
}.freeze

module SitemapHelper

  def record_data record
    {
      lastmod: record.updated_at,
      alternates: HOSTS.keys.map { |locale|
        I18n.with_locale(locale) do
          special_url = send(SPECIAL_PAGES[record.role.to_sym][:url]) if record.is_a?(StaticPage) and SPECIAL_PAGES.key?(record.role.to_sym)
          {
            href: special_url || polymorphic_path(record),
            lang: locale,
          }
        end
      },
      **(type_data(record) || {}),
    }
  end

  def type_data record
    if record.is_a?(::Meditation)
      return {
        video: {
          thumbnail_loc: record.image.url,
          content_loc: record.video.url,
          title: record.name,
          description: record.excerpt,
          # duration: nil, # TODO: Add this
          view_count: record.views,
          publication_date: record.created_at,
          family_friendly: true,
        }
      }
    elsif record.is_a?(::Treatment)
      return {
        video: {
          thumbnail_loc: record.thumbnail.url,
          content_loc: record.video.url,
          title: record.name,
          description: record.excerpt,
          family_friendly: true,
        }
      }
    end

    return unless record.is_a?(::Article) or record.is_a?(::StaticPage)

    data = { videos: [], images: [] }
    record.sections.each do |section|
      format = section.format.to_sym
      case section.content_type.to_sym
      when :text
        if format == :with_image
          image = section.media_file(section.extra_attr('image_id'))
          next if image.nil?
          data[:images] << {
            loc: image.file_url,
            title: image.name,
            caption: "#{I18n.t 'sections.credit'} • #{section.credit}",
          }
        end
      when :textbox
        unless format == :ancient_wisdom
          image = section.media_file(section.extra_attr('image_id'))
          next if image.nil?
          data[:images] << {
            loc: image.file_url,
            title: image.name,
          }
        end
      when :image
        if format == :image_gallery
          data[:images] += section.extra_attr('image_ids', []).map do |image_id|
            image = section.media_file(image_id)
            next if image.nil?
            {
              loc: image.file_url,
              title: image.name,
            }
          end
        else
          image = section.media_file(section.extra_attr('image_id'))
          next if image.nil?
          data[:images] << {
            loc: image.file_url,
            title: image.name,
            caption: "#{I18n.t 'sections.credit'} • #{section.credit}",
          }
        end
      when :video
        if format == :video_gallery
          data[:videos] += section.extra_attr('items', []).map do |item|
            image = section.image(item['image_id'])
            video = section.video(item['video_id'])
            next if image.nil? or video.nil?
            {
              thumbnail_loc: image.url,
              content_loc: image.url,
              title: item['title'],
              family_friendly: true,
            }
          end
        else
          image = section.image
          video = section.video
          next if image.nil? or video.nil?
          data[:videos] << {
            thumbnail_loc: section.image.url,
            content_loc: section.video.url,
            title: section.title,
            family_friendly: true,
          }
        end
      end
    end

    data
  end

end

SitemapGenerator::Interpreter.send :include, SitemapHelper

HOSTS.each do |locale, host|
  I18n.locale = locale
  SitemapGenerator::Sitemap.default_host = host
  SitemapGenerator::Sitemap.filename = "sitemap.#{locale}"
  SitemapGenerator::Sitemap.create do
    StaticPage.where.not(role: EXCLUDE_STATIC_PAGES).each do |static_page|
      role = static_page.role.to_sym

      if SPECIAL_PAGES.key? role
        add send(SPECIAL_PAGES[role][:url]), changefreq: SPECIAL_PAGES[role][:changefreq], **record_data(static_page)
      else
        add static_page_path(static_page), changefreq: 'yearly', **record_data(static_page)
      end
    end

    SubtleSystemNode.find_each do |subtle_system_node|
      add subtle_system_node_path(subtle_system_node), changefreq: 'yearly', **record_data(subtle_system_node)
    end

    Meditation.find_each do |meditation|
      add meditation_path(meditation), changefreq: 'yearly', **record_data(meditation)
    end

    Treatment.find_each do |treatment|
      add treatment_path(treatment), changefreq: 'yearly', **record_data(treatment)
    end

    Article.find_each do |article|
      add article_path(article), changefreq: 'yearly', **record_data(article)
    end
  end

end
=end