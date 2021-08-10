## SOCIAL HELPER
# Helps wth the rendering of social links

module SocialHelper

  SOCIAL_SHARE_URLS = {
    facebook: 'https://www.facebook.com/sharer/sharer.php?u=%{url}',
    twitter: 'https://twitter.com/intent/tweet?url=%{url}',
    pinterest: 'http://pinterest.com/pin/create/button/?url=%{url}',
    whatsapp: 'whatsapp://send?text=%{url}',
    vk: 'http://vk.com/share.php?url=%{url}',
  }

  SOCIAL_DATA = {
    default: {
      instagram: 'https://www.instagram.com/wemeditate.co',
      facebook: 'https://www.facebook.com/WeMeditateOfficial',
      sharing: %i[facebook twitter pinterest whatsapp],
    },
    ru: {
      instagram: 'https://www.instagram.com/wemeditate.ru',
      vk: 'https://vk.com/wemeditate',
      sharing: %i[facebook twitter pinterest whatsapp],
    },
    uk: {
      instagram: 'https://www.instagram.com/wemeditate.ua',
      facebook: 'https://www.facebook.com/WeMeditateUkraine',
      sharing: %i[facebook twitter pinterest whatsapp],
    },
  }

  # Fetch sharing links that can appear at the bottom of any article.
  def sharing_links
    url = ERB::Util.url_encode request.original_url.split('/', 3)[2]

    tag.div class: 'sharing_links' do
      concat tag.div I18n.translate('articles.share'), class: 'sharing_links__title'
      sharing_urls.each do |type, link|
        concat tag.a (tag.span class: "icon icon--#{type} icon"), class: 'sharing_links__item', href: link.gsub('%{url}', url)
      end
    end
  end

  def sharing_urls locale = Globalize.locale
    social_data(locale)[:sharing].map { |k| [k, SOCIAL_SHARE_URLS[k]] }
  end

  def social_media_urls locale = Globalize.locale
    social_data(locale).except(:sharing)
  end

  private

    def social_data locale
      SOCIAL_DATA.fetch(locale, SOCIAL_DATA[:default])
    end

end
