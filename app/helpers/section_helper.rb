## SECTION HELPER
# Functions to support page sections

module SectionHelper

  # TODO: In the future these should probably be defined in the CMS
  SUPPORTED_COUNTRY_MAPS = ['us', 'ru']
  COUNTRY_BOUNDS = {
    us: [[49.384472, -124.7844079], [24.446667, -66.9513812]]
  }

  # Creates the markup for a sidetext element, if content for that element has been defined.
  def sidetext section, wrap: false
    if section.has_decoration? :sidetext
      if wrap
        content_tag :div, section.decoration_sidetext, class: 'wrapper-outer for-sidetext' do
          content_tag :div, section.decoration_sidetext, class: "#{section.decoration_options(:sidetext).join(' ')} sidetext"
        end
      else
        content_tag :div, section.decoration_sidetext, class: "#{section.decoration_options(:sidetext).join(' ')} sidetext"
      end
    end
  end

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

  def venues_json city
    result = []

    city.venues&.each_with_index do |venue, index|
      result << {
        name: venue['address'],
        latitude: venue['latitude'],
        longitude: venue['longitude'],
        index: index,
      }
    end

    result.to_json
  end

end
