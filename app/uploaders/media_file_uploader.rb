# Media File is a generic type of attachment which is used to manage images in the body content of various models.
# In theory this uploader could support non-image uploads in the future.
# Such as MP3 tracks or PDF documents
class MediaFileUploader < ApplicationUploader

  include CarrierWave::MiniMagick

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

  # Get the metadata of an image so that it can be stored in the database for later.
  def get_metadata
    return nil unless file
    url = file.file
    url = file.file.url unless url.is_a?(String)
    width, height = ::MiniMagick::Image.open(url)[:dimensions]
    { width: width, height: height }
  end

end
