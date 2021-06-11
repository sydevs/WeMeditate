# Media File is a generic type of attachment which is used to manage images in the body content of various models.
# In theory this uploader could support non-image uploads in the future.
# Such as MP3 tracks or PDF documents
class MediaFileUploader < ApplicationUploader

  include CarrierWave::MiniMagick

  process :store_dimensions

  VERSIONS = {
    huge: 2880,
    large: 1440,
    medium: 720,
    small: 360,
    tiny: 180,
  }.freeze

  previous_version = nil
  VERSIONS.each do |name, version_width|
    version name, source: previous_version, &create_version(version_width)
    previous_version = name
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[png jpg jpeg]
  end

  # For now we are only supporting image types, but in the future a function like this would distinguish an image media file from other types of media files.
  def image? new_file
    new_file.content_type.start_with? 'image'
  end

  # Store width and height in model image_meta attribute
  def store_dimensions
    return nil unless file && model

    # Note: file on Heroku is CarrierWave::Storage::Fog::File but in dev it's
    # CarrierWave::SanitizedFile (whether GCLOUD_BUCKET is set or not).
    # Unfortunately don't have any explanation for the discrepancy.
    width, height = ::MiniMagick::Image.open(file.file)[:dimensions]
    model.image_meta = { width: width, height: height }
  end

end
