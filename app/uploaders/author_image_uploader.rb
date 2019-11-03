class AuthorImageUploader < ApplicationUploader

  include CarrierWave::MiniMagick
  process convert: :jpg # Author images should be photos, so JPG will do fine.

  VERSIONS = {
    large: 384, # For x3 retina
    medium: 256, # For x2 retina
    small: 128,
  }.freeze

  previous_version = nil
  VERSIONS.each do |name, version_width|
    version name, source: previous_version, &create_version(version_width)
    previous_version = name
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[jpg jpeg]
  end

end
