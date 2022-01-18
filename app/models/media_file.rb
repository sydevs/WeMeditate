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
    meta['type'] if meta
  end

  def to_h mode = nil
    if mode == :photoswipe
      return unless image?

      hash = { pid: id, src: file.url }
      hash[:msrc] = file.tiny.url if scalable_image?

      if meta && meta['width'] && meta['height']
        hash.merge! w: meta['width'], h: meta['height']
      else
        # Choose some plausible default if the metadata is missing.
        hash.merge! src: file.large.url, w: 1440, h: 900
      end

      hash
    else
      { id: id, src: file.url }.merge!(meta)
    end
  end

  def audio?
    mime_type&.starts_with?('audio/')
  end

  def image?
    mime_type.nil? || mime_type.starts_with?('image/')
  end

  def scalable_image? _image = nil
    image? && !%w[image/gif image/svg image/svg+xml].include?(mime_type)
  end

end
