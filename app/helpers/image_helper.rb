module ImageHelper

  STATIC_IMAGE_PNGS = %w[meditations/prescreen-foreground].freeze
  STATIC_IMAGE_VERSIONS = {
    'meditations/prescreen-background' => { large: 1920, medium: 960, small: 480 },
    'meditations/prescreen-foreground' => { large: 1920, medium: 960, small: 480 },
    'music/album' => { large: 900, medium: 500, small: 225 },
    'music/treatment' => { medium: 400, small: 200 },
    'meditations/random' => { large: 1920 }, # TODO: Optimize this for different resolutions, and it's max width which is much lower than 1920
  }.freeze

  def smart_image_tag source, sizes, **args
    srcset = []
    webp_srcset = []

    source.versions.values.each do |version|
      srcset << "#{version.url} #{version.width}w"
      webp_srcset << "#{version.webp.url} #{version.width}w"
    end

    srcset = srcset.join(', ')
    webp_srcset = webp_srcset.join(', ')

    args[:alt] ||= source.identifier

    capture do
      concat content_tag(:noscript, tag.img(src: source.url, **args))
      concat picture_tag(source.url, srcset, webp_srcset, sizes, **args)
    end
  end

  def static_image_tag path, sizes, **args
    raise "No versions defined for static image '#{path}'" unless STATIC_IMAGE_VERSIONS.key?(path)

    extension = STATIC_IMAGE_PNGS.include?(path) ? 'png' : 'jpg'
    srcset = []
    webp_srcset = []

    STATIC_IMAGE_VERSIONS[path].each do |name, width|
      srcset << "#{path_to_image("#{path}-#{name}.#{extension}")} #{width}w"
      webp_srcset << "#{path_to_image("#{path}-#{name}.webp")} #{width}w"
    end

    src = srcset.first.split(' ')[0]
    srcset = srcset.join(', ')
    webp_srcset = webp_srcset.join(', ')

    capture do
      concat content_tag(:noscript, tag.img(src: src, **args))
      concat picture_tag(src, srcset, webp_srcset, sizes, **args)
    end
  end

  def vimeo_image_tag vimeo_object, sizes, **args
    picture_tag vimeo_object[:thumbnail], vimeo_object[:thumbnail_srcset], nil, sizes, **args
  end

  def picture_tag _src, srcset, webp_srcset, sizes, **args
    lazy = args.key?(:lazy) ? args[:lazy] : true
    args.except!(:lazy)

    content_tag :picture do
      if lazy
        args[:class] ||= ''
        args[:class] << ' js-image'

        concat tag.source type: 'image/webp', data: { srcset: webp_srcset, sizes: sizes } unless webp_srcset.nil?
        concat tag.img data: { srcset: srcset, sizes: sizes }, **args
      else
        concat tag.source type: 'image/webp', srcset: webp_srcset, sizes: sizes unless webp_srcset.nil?
        concat tag.img srcset: srcset, sizes: sizes, **args
      end
    end
  end

end
