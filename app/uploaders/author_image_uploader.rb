class AuthorImageUploader < ApplicationUploader

  include CarrierWave::MiniMagick
  process convert: :jpg

  VERSIONS = {
    large: 384, # For x3 retina
    medium: 256, # For x2 retina
    small: 128,
  }.freeze

  VERSIONS.each do |name, version_width|
    version name, &create_version(version_width)
  end

  def extension_whitelist
    %w[jpg jpeg]
  end

end
