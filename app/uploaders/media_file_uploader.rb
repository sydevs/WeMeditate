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
    version name, if: :image? do
      create_version(version_width).call
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[png jpg jpeg]
  end

  def image? new_file
    new_file.content_type.start_with? 'image'
  end

end
