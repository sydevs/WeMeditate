module NavigationHelper

  def navigation
    if not defined? @navigation
      @navigation = []

      [:meditations, :articles, :tracks].each do |role|
        static_page = static_page_preview_for(role)
        @navigation.push({
          title: static_page.title,
          url: static_page_path_for(static_page),
          active: controller_name == role.to_s
        })
      end

      @navigation.push({
        title: I18n.translate('header.learn_more'),
        url: '#', #static_page_path_for(static_page_preview_for(:about)),
        active: ['static_pages', 'subtle_system_nodes'].include?(controller_name),
        content: {
          items: [:about, :contact, :sahaja_yoga, :shri_mataji, :subtle_system, :treatments].map { |role|
            static_page = static_page_preview_for(role)
            {
              title: static_page.title,
              url: static_page_path_for(static_page),
            }
          },
          featured: Treatment.includes_preview.first(2).map { |treatment|
            {
              title: "#{Treatment.model_name.human}: #{treatment.name}",
              url: treatment_path(treatment),
              thumbnail: treatment.thumbnail.url,
            }
          }
        }
      })
    end

    @navigation.each do |item|
      yield item
    end
  end

  def mobile_navigation
    home_page = static_page_preview_for(:home)
    yield ({
      title: home_page.title,
      url: static_page_path_for(home_page),
      active: controller_name == 'application' && action_name == 'front',
    })

    navigation do |nav|
      yield nav
    end

    yield ({
      title: I18n.translate('header.classes_near_me').gsub('<br>', ' '),
      url: local_cities_path,
      active: controller_name == 'cities',
    })
  end

  def sharing_links
    url = ERB::Util.url_encode request.original_url.split('/', 3)[2]

    tag.div class: 'sharing-footer' do
      tag.div class: 'wrapper-inner' do
        concat tag.div I18n.t('sharing_footer.title'), class: 'sharing-footer-title'
        I18n.translate('sharing').collect do |type, link|
          concat tag.a (tag.i class: "#{type} icon"), class: 'sharing-footer-item', href: link.gsub('%{url}', url)
        end
      end
    end
  end
end
