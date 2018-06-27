module NavigationHelper

  def navigation
    @desktop_navigation ||= [
      {
        title: 'Meditation Now',
        url: meditations_path,
        active: controller_name == 'meditations',
      },
      {
        title: 'Inspiration',
        url: articles_path,
        active: controller_name == 'articles',
      },
      {
        title: 'Music',
        url: tracks_path,
        active: controller_name == 'tracks',
      },
      {
        title: 'Learn More',
        url: static_page_path(StaticPage.find_by(role: :about)),
        active: ['static_pages', 'subtle_system_nodes'].include?(controller_name),
        content: {
          items: StaticPage.where(role: [:about, :sahaja_yoga, :shri_mataji, :subtle_system]).map {|static_page| {
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
    ]

    @desktop_navigation.each do |item|
      yield item
    end
  end

end
