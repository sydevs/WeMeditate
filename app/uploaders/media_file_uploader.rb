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
    version name, if: :image?, &create_version(version_width)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[png jpg mp4]
  end

  def image? new_file
    # `casecmp` is a case-insensitive string comparison.
    new_file.content_type.start_with? 'image'
  end

end
