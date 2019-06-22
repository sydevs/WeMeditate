module NavigationHelper

  def navigation_items
    return @navigation if defined? @navigation

    @navigation = []

    %i[meditations articles tracks].each do |role|
      static_page = static_page_preview_for(role)
      @navigation.push({
        title: static_page.name,
        url: static_page_path_for(static_page),
        active: controller_name == role.to_s,
      })
    end

    @navigation.push({
      title: I18n.translate('header.learn_more'),
      url: '#', # static_page_path_for(:about),
      active: %w[static_pages subtle_system_nodes].include?(controller_name),
      content: {
        items: %i[about contact sahaja_yoga shri_mataji subtle_system treatments].map { |role|
          static_page = static_page_preview_for(role)
          {
            title: static_page.name,
            url: static_page_path_for(static_page),
          }
        },
        featured: Treatment.preload_for(:preview).first(2).map { |treatment|
          {
            title: "#{Treatment.model_name.human}: #{treatment.name}",
            url: treatment_path(treatment),
            thumbnail: treatment.thumbnail.url,
          }
        },
      },
    })

    @navigation
  end

  def mobile_navigation_items
    mobile_navigation = []
    # home_page = static_page_preview_for(:home)

    # mobile_navigation.push({
    #   title: home_page.name,
    #   url: static_page_path_for(home_page),
    #   active: controller_name == 'application' && action_name == 'home',
    # })

    mobile_navigation += navigation_items

    mobile_navigation.push({
      title: I18n.translate('header.classes_near_me').gsub('<br>', ' '),
      url: static_page_path_for(:classes),
      active: controller_name == 'classes',
    })

    mobile_navigation
  end

  def sharing_links
    url = ERB::Util.url_encode request.original_url.split('/', 3)[2]

    tag.div class: 'sharing_links' do
      concat tag.div I18n.translate('share'), class: 'sharing_links__title'
      I18n.translate('sharing').collect do |type, link|
        concat tag.a (tag.i class: "#{type} icon"), class: 'sharing_links__item', href: link.gsub('%{url}', url)
      end
    end
  end

end
