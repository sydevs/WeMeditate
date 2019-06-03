## SECTION HELPER
# Functions to support page sections

module SectionHelper

  # Creates the markup for a sidetext element, if content for that element has been defined.
  def sidetext section, wrap: false
    return unless section.has_decoration? :sidetext

    if wrap
      content_tag :div, section.decoration_sidetext, class: 'wrapper-outer for-sidetext' do
        content_tag :div, section.decoration_sidetext, class: "#{section.decoration_options(:sidetext).join(' ')} sidetext"
      end
    else
      content_tag :div, section.decoration_sidetext, class: "#{section.decoration_options(:sidetext).join(' ')} sidetext"
    end
  end

  def venues_map_url
    'http://sahajdb.herokuapp.com/venues/map'
  end

end
