## MEDIA FILE

# TYPE: FILE
# A file that can be attached to any file

class MediaFile < ActiveRecord::Base

  extend CarrierWave::Meta::ActiveRecord
  include Translatable

  META_FIELDS = %i[width height].freeze
  META_DATA = ([{ image: META_FIELDS }] + MediaFileUploader::VERSIONS.keys.map { |version| { "image_#{version}".to_sym => META_FIELDS } }).freeze

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, ImageUploader
  serialize :image_meta, OpenStruct
  carrierwave_meta_composed :image_meta, *META_DATA # TODO: Image data is not actually being saved

  # Validations
  validates :file, presence: true

  def name
    File.basename(URI.parse(file.url).path)
  end

  # This is to be rendered as a json and used by the photoswipe gallery
  def to_h
    if image_width.present? && image_height.present?
      { pid: id, src: file.url, msrc: file.tiny.url, w: image_width, h: image_height }
    else
      # Choose some plausible default if the metadata is missing.
      { pid: id, src: file.large.url, msrc: file.tiny.url, w: 1440, h: 900 }
    end
  end

end
