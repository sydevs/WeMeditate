module MetadataHelper

  ORGANIZATION = {
    '@type' => 'Organization',
    'name' => I18n.translate('we_meditate'),
    'logo' => {
      '@type' => 'ImageObject',
      'url' => ApplicationController.helpers.image_path('header/logo.svg'),
    },
    'sameAs' => I18n.translate('social_media').values,
  }.freeze

  def render_metatags
    return unless @metatags.present?

    capture do
      @metatags.each do |key, value|
        if key == 'title'
          concat tag.title "#{value} | #{translate 'we_meditate'}"
        elsif key == 'description'
          concat tag.meta name: 'description', content: value
        elsif value.is_a? Array
          value.each do |val|
            concat tag.meta property: key, content: val
          end
        else
          concat tag.meta property: key, content: value
        end
      end
    end
  end

  def render_structured_data
    return unless @structured_data.present?

    tag.script @structured_data.to_json.html_safe, type: 'application/ld+json'
  end

  def metatags record = nil
    @metatags ||= (record&.metatags || {}).reverse_merge(default_metatags(record))
  end

  def default_metatags record = nil
    @default_metatags ||= begin
      tags = {
        'og:site_name' => translate('we_meditate'),
        'og:url' => request.original_url,
        'og:locale' => locale,
        'twitter:site' => Rails.application.config.twitter_handle,
        'twitter:creator' => Rails.application.config.twitter_handle,
      }

      if record.present?
        tags['og:locale:alternate'] = record.translated_locales.map(&:to_s)
        tags['og:article:published_time'] = record.created_at.to_s(:db)
        tags['og:article:modified_time'] = record.updated_at.to_s(:db)
        tags['title'] = record.name
      else
        tags['og:locale:alternate'] = I18n.available_locales.map(&:to_s)
      end

      if record&.has_content?
        tags['og:article:modified_time'] = record.updated_at.to_s(:db)
      end

      # rubocop:disable Performance/RedundantMerge
      case record
      when Article
        if record.video.present?
          tags.merge!({
            'description' => record.excerpt,
            'og:type' => 'video.other',
            'og:image' => record.thumbnail&.url,
            # 'og:video' => record.video&.url, # TODO: Make this work with the new Vimeo integration
            # 'og:video:duration' => '', # TODO: Define this
            # 'og:video:release_date' => record.created_at.to_s(:db),
            'twitter:card' => 'player',
            # 'twitter:player:url' => '', # TODO: We must have an embeddable video iframe to reference here.
            # 'twitter:player:width' => '',
            # 'twitter:player:height' => '',
          })
        else
          tags.merge!({
            'description' => record.excerpt,
            'og:type' => 'article',
            'og:image' => record.banner&.url || record.thumbnail&.url,
            'og:article:section' => record.category.name,
            'og:article:modified_time' => record.updated_at.to_s(:db),
            'twitter:card' => record.banner.present? ? 'summary_large_image' : 'summary',
            # 'og:video' => record.video&.url, # TODO: Make this work with the new Vimeo integration
            # 'og:video:duration' => '', # TODO: Define this
          })
        end
      when StaticPage
        is_article = %w[about shri_mataji subtle_system sahaja_yoga tracks meditations treatments].include? record.role
        tags['title'] = translate('we_meditate') if record.role == 'home'

        tags.merge!({
          'og:url' => static_page_url_for(record),
          'og:type' => is_article ? 'article' : 'website',
          'og:article:modified_time' => record.updated_at.to_s(:db),
          'twitter:card' => 'summary',
        })
      when Meditation, Treatment
        tags.merge!({
          'og:type' => 'video.other',
          'og:image' => record.thumbnail&.url,
          # 'og:video' => record.video&.url, # TODO: Make this work with the new Vimeo integration
          # 'og:video:duration' => '', # TODO: Define this
          # 'og:video:release_date' => record.created_at.to_s(:db),
          'twitter:card' => 'player',
          # 'twitter:player:url' => '', # TODO: We must have an embeddable video iframe to reference here.
          # 'twitter:player:width' => '',
          # 'twitter:player:height' => '',
        })
      when SubtleSystemNode
        tags.merge!({
          'og:type' => 'article',
          'twitter:card' => 'summary',
        })
      end

      tags.merge!({
        'og:title' => tags['title'],
        'og:description' => tags['description'],
      })
      # rubocop:enable Performance/RedundantMerge
    end
  end

  def structured_data record
    return unless @metatags.present?

    tags = @metatags
    @structured_data ||= begin
      objects = []
      page = {
        '@context' => 'http://schema.org',
        'mainEntityOfPage' => {
          '@type' => 'WebPage',
          '@id' => tags['og:url'],
        },
        'publisher' => ORGANIZATION,
        'name' => tags['og:title'],
        'description' => tags['og:description'],
        'datePublished' => tags['og:article:published_time'],
        'dateModified' => tags['og:article:modified_time'],
        'image' => tags['og:image'],
        'video' => tags['og:video'],
      }

      objects.push(page)

      # rubocop:disable Performance/RedundantMerge
      case record
      when Article
        page.merge!({
          '@type' => 'Article',
          'headline' => tags['og:title'],
          'thumbnail_url' => record.thumbnail&.url,
        })

        if record.date.present?
          objects.push({
            '@context' => 'http://schema.org',
            '@type' => 'Event',
            'publisher' => ORGANIZATION,
            'name' => tags['og:title'],
            'description' => tags['og:description'],
            'startDate' => record.date.to_s(:db),
            'image' => tags['og:image'],
            'video' => tags['og:video'],
            # 'location' => {}, # TODO: Define this - https://developers.google.com/search/docs/data-types/event
          })
        end

        if record.video.present?
          objects.push({
            '@context' => 'http://schema.org',
            '@type' => 'VideoObject',
            'publisher' => ORGANIZATION,
            'name' => tags['og:title'],
            'description' => tags['og:description'],
            'thumbnail_url' => record.thumbnail&.url,
            'uploadDate' => tags['og:article:published_time'],
            'image' => tags['og:image'],
            'contentUrl' => tags['og:video'],
            'embedUrl' => tags['twitter:player:url'],
            'duration' => tags['og:video:duration'],
          })
        end
      when StaticPage
        if %w[about shri_mataji sahaja_yoga tracks].include? record.role
          page.merge!({
            '@type' => 'Article',
            'headline' => tags['og:title'],
            'thumbnail_url' => tags['og:image'],
          })
        elsif record.role == 'contact'
          # TODO: Add special markup for this page
          page.merge!({
            '@type' => 'WebPage',
          })
        else
          page.merge!({
            '@type' => 'WebPage',
          })
        end

        if %w[articles meditations treatments subtle_system].include? record.role
          list = {
            '@context' => 'https://schema.org',
            '@type' => 'ItemList',
            'itemListElement' => {},
          }

          records_name = (record.role == 'subtle_system' ? 'subtle_system_nodes' : record.role)
          records = instance_variable_get("@#{records_name}")
          if records
            list['itemListElement'] = records.each_with_index.map do |item, index|
              {
                '@type' => 'ListItem',
                'position' => index,
                'url' => polymorphic_url(item),
              }
            end
          end

          # if 'admin'
          #   list['itemListElement'] = "<list of #{records_name}>"
          # else
          #   list['itemListElement'] = instance_variable_get("@#{records_name}").each_with_index.map { |record, index|
          #     {
          #       '@type' => 'ListItem',
          #       'position' => index,
          #       'url' => polymorphic_url(record),
          #     }
          #   }
          # end

          objects.push list
        end
      when Meditation, Treatment
        page.merge!({
          '@type' => 'VideoObject',
          'publisher' => ORGANIZATION,
          'thumbnail_url' => record.thumbnail&.url,
          'uploadDate' => tags['og:article:published_time'],
          'contentUrl' => tags['og:video'],
          'embedUrl' => tags['twitter:player:url'],
          'duration' => tags['og:video:duration'],
          'interactionCount' => (record.views if defined? record.views), # TODO: Make sure that we use a consistent increasing number here, and maybe make treatments support it
        })
      when SubtleSystemNode
        page.merge!({
          '@type' => 'Article',
          'headline' => tags['og:title'],
        })
      end
      # rubocop:enable Performance/RedundantMerge

      if @breadcrumbs
        objects.push {
          {
            '@context': 'https://schema.org',
            '@type': 'BreadcrumbList',
            'itemListElement': @breadcrumbs.each_with_index.map { |crumb, index|
              {
                '@type' => 'ListItem',
                'position' => index,
                'name' => crumb[:name],
                'item' => crumb[:url] || tags['og:url'],
              }
            },
          }
        }
      end

      objects
    end
  end

end
