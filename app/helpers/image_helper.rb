## IMAGE HELPER
# Helpers for rendering responnsive, lazyloaded, webp images.

module ImageHelper

  # Note: "Static images" are images which are stored in the server files, rather than being uploaded to Google Cloud through CarrierWave

  # Definitions for statis images which are PNGs
  STATIC_IMAGE_PNGS = %w[
    home/scotland
    meditations/prescreen-foreground
  ].freeze

  # Definitions of the different versions available for some static images.
  STATIC_IMAGE_VERSIONS = {
    'meditations/prescreen-background' => { large: 1920, medium: 960, small: 480 },
    'meditations/prescreen-foreground' => { large: 1920, medium: 960, small: 480 },
    'music/album' => { large: 900, medium: 500, small: 225 },
    'music/treatment' => { medium: 400, small: 200 },
    'meditations/random' => { large: 1200, medium: 800, small: 400 },
  }.freeze

  HOMEPAGE_IMAGES = %w[
    home/scotland
    home/russian-field
    home/malaysian-yuvas
  ].freeze

  def homepage_image_url
    month = Date.today.strftime('%m').to_i
    path = HOMEPAGE_IMAGES[(month / HOMEPAGE_IMAGES.count).to_i]
    extension = STATIC_IMAGE_PNGS.include?(path) ? 'png' : 'jpg'
    asset_pack_path "media/images/#{path}.#{extension}"
  end

  # Takes care of all the complicated rendering generate a picture tag that supports webp, lazyloading, and responsive images.
  # `source` should be a CarrierWave image
  # `sizes` should be a "sizes" definition as per the HTML5 <picture> tag specification (look it up)
  def smart_image_tag source, sizes, **args
    if source.is_a?(MediaFileUploader)
      raise ArgumentError, "Media file is not an image (#{source.type})" unless source.image?
      return image_tag(source.url, **args) unless source.scalable_image?
    end

    srcset = []
    webp_srcset = []

    # Generate the srcset for both the webp, and fallback versions of the image.
    # This srcset will include every responsive image version available.
    source.versions.values.each do |version|
      srcset << "#{version.url} #{version.width}w"
      webp_srcset << "#{version.webp.url} #{version.width}w"
    end

    # Merge the srcsets into one string
    srcset = srcset.join(', ')
    webp_srcset = webp_srcset.join(', ')

    # Set the alt text to be the image file name, if an alt text has not been set.
    args[:alt] ||= source.identifier

    capture do
      # Render a basic fallback incase javascript isn't enabled/supported
      concat content_tag(:noscript, tag.img(src: source.url, **args))
      # Pass our components to another function to build the picture tag
      concat picture_tag(source.url, srcset, webp_srcset, sizes, **args)
    end
  end

  # This helper takes care of the code necessary to render a static image that is webp, responsive, and lazyloaded
  def static_image_tag path, sizes, **args
    # If responsive versions have no been defined, an error is thrown
    raise "No versions defined for static image '#{path}'" unless STATIC_IMAGE_VERSIONS.key?(path)

    # Get the proper extension for this image
    extension = STATIC_IMAGE_PNGS.include?(path) ? 'png' : 'jpg'
    srcset = []
    webp_srcset = []

    # Generate the srcset for both the webp, and fallback versions of the image.
    # This srcset will include every responsive image version available.
    STATIC_IMAGE_VERSIONS[path].each do |name, width|
      srcset << "#{asset_pack_path("media/images/#{path}-#{name}.#{extension}")} #{width}w"
      webp_srcset << "#{asset_pack_path("media/images/#{path}-#{name}.webp")} #{width}w"
    end

    # Get the first value of the srcset to be our default src
    src = srcset.first.split(' ')[0]

    # Merge the srcsets into one string
    srcset = srcset.join(', ')
    webp_srcset = webp_srcset.join(', ')

    capture do
      # Render a basic fallback incase javascript isn't enabled/supported
      concat content_tag(:noscript, tag.img(src: src, **args))
      # Pass our components to another function to build the picture tag
      concat picture_tag(src, srcset, webp_srcset, sizes, **args)
    end
  end

  # Renders a responsive and lazyloaded image from Vimeo metadata
  def vimeo_image_tag vimeo_object, sizes, **args
    capture do
      # Render a basic fallback incase javascript isn't enabled/supported
      concat content_tag(:noscript, tag.img(src: vimeo_object[:thumbnail], **args))
      # Pass our components to another function to build the picture tag
      concat picture_tag(vimeo_object[:thumbnail], vimeo_object[:thumbnail_srcset], nil, sizes, **args)
    end
  end

  # Given all the components, render an HTML5 <picture> tag, which supports WEBP, lazyloading, and responsive images.
  def picture_tag _src, srcset, webp_srcset, sizes, **args
    lazy = args.key?(:lazy) ? args[:lazy] : true
    args.except!(:lazy)

    content_tag :picture do
      if lazy
        # Add the js-image class if this image is lazyloaded
        args[:class] ||= ''
        args[:class] << ' js-image'
        args[:src] = 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='

        # Use `data` attributes for a lazyloaded image
        concat tag.source type: 'image/webp', data: { srcset: webp_srcset, sizes: sizes } unless webp_srcset.nil?
        concat tag.img data: { srcset: srcset, sizes: sizes }, **args
      else
        concat tag.source type: 'image/webp', srcset: webp_srcset, sizes: sizes unless webp_srcset.nil?
        concat tag.img srcset: srcset, sizes: sizes, **args
      end
    end
  end

  def inline_svg_tag src, **attrs
    inline_svg_pack_tag "media/images/#{src}", **attrs
  end

  # Return the full url to a an image, instead of just the path. Useful for metadata
  def image_url source
    source.delete_prefix!('/')

    if source.starts_with?('uploads')
      path_to_url source
    elsif !source.starts_with?('http')
      path_to_url asset_pack_path("media/images/#{source}")
    else
      source
    end
  end

end
