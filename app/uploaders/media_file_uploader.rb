# Media File is a generic type of attachment which is used to manage images in the body content of various models.
# In theory this uploader could support non-image uploads in the future.
# Such as MP3 tracks or PDF documents
class MediaFileUploader < ApplicationUploader

  include CarrierWave::MiniMagick

  process :store_meta
  delegate :type, :image?, :scalable_image?, to: :model

  VERSIONS = {
    huge: 2880,
    large: 1440,
    medium: 720,
    small: 360,
    tiny: 180,
  }.freeze

  previous_version = nil
  VERSIONS.each do |name, version_width|
    version name, source: previous_version, if: :scalable_image?, &create_version(version_width)
    previous_version = name
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[png jpg jpeg gif svg]
  end

  # Store width and height in model image_meta attribute
  def store_meta
    return nil unless file && model

    # Note: file on Heroku is CarrierWave::Storage::Fog::File but in dev it's
    # CarrierWave::SanitizedFile (whether GCLOUD_BUCKET is set or not).
    # Unfortunately don't have any explanation for the discrepancy.
    parsed_file = ::MiniMagick::Image.open(file.file)
    width, height = parsed_file[:dimensions]
    model.image_meta = { width: width, height: height, type: parsed_file[:mime_type] }
  end

end
