## NAVIGATON HELPER
# This helper generates the elements of the header's navigation bar

module NavigationHelper

  # Return a list of navigation items for desktop
  def navigation_items
    @navigation_items ||= begin
      result = []

      # Collect the three basic navigaton links
      %i[meditations tracks articles].each do |role|
        static_page = static_page_preview_for(role)
        result.push({
          title: static_page.name,
          url: static_page_path_for(static_page),
          active: controller_name == role.to_s,
          data: gtm_record(static_page),
        })
      end

      # Define the dropdown navigation.
      result.push(advanced_navigation_item)

      result
    end
  end

  # Return a list of navigation items for mobile
  def mobile_navigation_items
    @mobile_navigation_items ||= begin
      result = []

      # Collect the four basic navigaton links
      %i[meditations tracks streams articles].each do |role|
        return if role == :streams && !Stream.public_stream.any?

        static_page = static_page_preview_for(role)
        result.push({
          title: role == :streams ? translate('header.live_meditations') : static_page.name,
          url: static_page_path_for(static_page),
          active: controller_name == role.to_s,
          data: gtm_record(static_page),
        })
      end

      # Define the dropdown navigation.
      result.push(advanced_navigation_item)

      result
    end
  end

  def advanced_navigation_item
    @advanced_navigation_item ||= begin
      kundalini_page = SubtleSystemNode.find_by(role: :kundalini)
      static_pages = %i[shri_mataji sahaja_yoga subtle_system treatments].map { |role|
        static_page = static_page_preview_for(role)
        [role, {
          title: static_page.name,
          url: static_page_path_for(static_page),
          data: gtm_record(static_page),
        }]
      }.to_h

      {
        title: I18n.translate('header.advanced'),
        url: '#',
        data: gtm_label('header.advanced'),
        active: %w[static_pages subtle_system_nodes].include?(controller_name),
        content: {
          items: [
=begin
            {
              title: translate('header.advanced_articles'),
              url: '#', # static_page_path_for(static_page),
              # data: gtm_record(static_page),
            },
=end
            static_pages[:subtle_system],
            {
              title: translate('header.kundalini'),
              url: url_for(kundalini_page),
              data: gtm_record(kundalini_page),
            },
            static_pages[:shri_mataji],
            static_pages[:sahaja_yoga],
            static_pages[:treatments],
          ],
          featured: Article.published.preload_for(:preview).reorder("RANDOM()").limit(2).map { |article|
            {
              title: article.name,
              url: article_path(article),
              data: gtm_record(article),
              thumbnail: article.thumbnail.url,
            }
          },
        },
      }
    end
  end

end
