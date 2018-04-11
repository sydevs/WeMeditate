module NavigationHelper

  def navigation
    @desktop_navigation ||= [
      {
        title: 'Meditations', label: 'Meditate now!', url: meditations_path,
        #content: {
        #  items: DurationFilter.first(5).reverse.map {|df| {
        #    title: duration_filter_name(df),
        #    url: meditations_url(duration: df.minutes),
        #  }},
        #  featured: Meditation.first(2).map {|meditation| {
        #    title: meditation.name,
        #    url: meditation_url(meditation),
        #    thumbnail: meditation.image.url,
        #  }},
        #}
      },
      {
        title: 'Inspiration', url: articles_path,
        #content: {
        #  items: Article.offset(2).first(5).map {|article| {
        #    title: article.title,
        #    url: article_url(article),
        #  }},
        #  featured: Article.first(2).map {|article| {
        #      title: article.title,
        #      url: article_url(article),
        #      thumbnail: article.thumbnail.url,
        #  }}
        #}
      },
      { title: 'Music', url: tracks_path },
      {
        title: 'Learn More', url: static_page_path(StaticPage.find_by(role: :about)),
        content: {
          items: StaticPage.where(role: [:about, :sahaja_yoga, :shri_mataji, :kundalini, :subtle_system]).map {|static_page| {
            title: static_page.title,
            url: static_page_path(static_page),
          }} + [{
            title: StaticPage.find_by(role: :treatments).title,
            url: treatments_path,
          }],
          featured: Treatment.first(2).map {|treatment| {
            title: "#{Treatment.model_name.human}: #{treatment.name}",
            url: treatment_path(treatment),
            thumbnail: treatment.thumbnail.url,
          }}
        }
      },
      { title: 'Come meditate', url: cities_path },
    ]

    p @desktop_navigation

    @desktop_navigation.each do |item|
      yield item
    end
  end

end
