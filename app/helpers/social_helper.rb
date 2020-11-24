## SOCIAL HELPER
# Helps wth the rendering of social links

module SocialHelper

  SHARING_URLS = {
    facebook: 'https://www.facebook.com/sharer/sharer.php?u=%{url}',
    twitter: 'https://twitter.com/intent/tweet?url=%{url}',
    pinterest: 'http://pinterest.com/pin/create/button/?url=%{url}',
    whatsapp: 'whatsapp://send?text=%{url}',
    vk: 'http://vk.com/share.php?url=%{url}',
    flipboard: 'https://share.flipboard.com/bookmarklet/popout?v=2&title={title}&url={url}',
    linkedin: 'https://www.linkedin.com/shareArticle?url={url}&title={title}&summary={text}&source={provider}',
    email: 'mailto:?subject=&body={url}'
  }

  SHARING_DATA = {
    default: {
      articles: %i[facebook twitter pinterest flipboard],
      meditations: %i[email facebook twitter linkedin],
    },
    ru: {
      articles: %i[vk],
      meditations: %i[email vk],
    },
  }

  SOCIAL_DATA = {
    default: {
      instagram: 'https://www.instagram.com/wemeditate.co',
      facebook: 'https://www.facebook.com/WeMeditateOfficial',
    },
    ru: {
      instagram: 'https://www.instagram.com/wemeditate.ru',
      vk: 'https://vk.com/wemeditate',
    },
  }

  # Fetch sharing links that can appear at the bottom of any article.
  def sharing_links location: :articles
    url = ERB::Util.url_encode request.original_url.split('/', 3)[2]

    tag.div class: 'sharing_links' do
      concat tag.div I18n.translate('articles.share'), class: 'sharing_links__title'
      sharing_urls(location).each do |type, link|
        concat tag.a (tag.span class: "icon icon--#{type}"), class: 'sharing_links__item', href: link.gsub('%{url}', url)
      end
    end
  end

  def sharing_urls location = :articles, locale = Globalize.locale
    data = SHARING_DATA.fetch(locale, SHARING_DATA[:default])[location]
    data.map { |k| [k, SHARING_URLS[k]] }
  end

  def social_media_urls locale = Globalize.locale
    SOCIAL_DATA.fetch(locale, SOCIAL_DATA[:default])
  end

end
