## MEDIA FILE

# TYPE: FILE
# A file that can be attached to any file

class MediaFile < ActiveRecord::Base

  extend CarrierWave::Meta::ActiveRecord

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, MediaFileUploader

  # Validations
  validates :file, presence: true

  # Methods

  def name
    File.basename(URI.parse(file.url).path)
  end

  def preview_url
    scalable_image? ? file.small.url : file.url
  end

  def type
    image_meta['type'] if image_meta
  end

  # This is to be rendered as a json and used by the photoswipe gallery
  def to_h
    return nil unless image?

    hash = { pid: id, src: file.url }
    hash[:msrc] = file.tiny.url if scalable_image?

    if image_meta && image_meta['width'] && image_meta['height']
      hash.merge! w: image_meta['width'], h: image_meta['height']
    else
      # Choose some plausible default if the metadata is missing.
      hash.merge! src: file.large.url, w: 1440, h: 900
    end

    hash
  end

  def image?
    !image_meta.present? || !image_meta['type'].present? || image_meta['type'].starts_with?('image/')
  end

  def scalable_image? _image = nil
    image? && (!image_meta.present? || !%w[image/gif image/svg image/svg+xml].include?(image_meta['type']))
  end

end
