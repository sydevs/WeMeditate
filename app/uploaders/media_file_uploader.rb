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

  VERSIONS.each do |name, version_width|
    version name, &create_version(version_width)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[png jpg jpeg]
  end

  def image? new_file
    new_file.content_type.start_with? 'image'
  end

  def get_metadata
    return nil unless file
    url = file.file
    url = file.file.url unless url.is_a?(String)
    width, height = ::MiniMagick::Image.open(url)[:dimensions]
    { width: width, height: height }
  end

end
