## MEDIA FILE

# TYPE: FILE
# A file that can be attached to any file

class MediaFile < ActiveRecord::Base

  extend CarrierWave::Meta::ActiveRecord
  include Translatable

  after_save :save_metadata

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, ImageUploader

  # Validations
  validates :file, presence: true

  def name
    File.basename(URI.parse(file.url).path)
  end

  # This is to be rendered as a json and used by the photoswipe gallery
  def to_h
    if image_meta && image_meta['width'] && image_meta['height']
      { pid: id, src: file.url, msrc: file.tiny.url, w: image_meta['width'], h: image_meta['height'] }
    else
      # Choose some plausible default if the metadata is missing.
      { pid: id, src: file.large.url, msrc: file.tiny.url, w: 1440, h: 900 }
    end
  end

  def save_metadata
    return if file.nil? || image_meta.nil?

    width, height = `identify -format "%wx%h" #{file.path}`.split(/x/)
    update!(image_meta: { width: width, height: height })
  end

end
