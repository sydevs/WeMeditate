module SectionHelper

  SUPPORTED_COUNTRY_MAPS = ['us', 'ru']
  COUNTRY_BOUNDS = {
    us: [[49.384472, -124.7844079], [24.446667, -66.9513812]]
  }

  def subtle_system_pages
    StaticPage.where(role: [:chakra_1, :chakra_2, :chakra_3, :chakra_3b, :chakra_4, :chakra_5, :chakra_6, :chakra_7, :channel_left, :channel_right, :channel_center])
  end

  def country_url_json
    I18nData.countries(locale).map do |country_code, country_name|
      [country_name, country_path(country_code: country_code)]
    end
  end

  def country_map_supported? country_code
    SUPPORTED_COUNTRY_MAPS.include? country_code.downcase
  end

  def country_bounds_json country_code
    COUNTRY_BOUNDS[country_code.downcase.to_sym].to_json
  end

  def cities_json country_code
    result = []

    City.with_translations(locale).where(country: City.countries[country_code]).each do |city|
      result << {
        name: city.name,
        latitude: city.latitude,
        longitude: city.longitude,
        url: city_path(city),
      }
    end

    result.to_json
  end

  def markdown content, &block
    @r ||= MarkdownRenderer.new
    @r.callout = (block_given? ? capture(&block) : nil)

    @rc ||= Redcarpet::Markdown.new(@r, no_intra_emphasis: true, autolink: true, space_after_headers: true, filter_html: true)
    @rc.render(content).html_safe
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    attr_writer :callout

    def paragraph text
      if @callout
        result = %(<p>#{text}</p>#{@callout})
        @callout = nil
        result
      else
        %(<p>#{text}</p>)
      end
    end
  end

end
