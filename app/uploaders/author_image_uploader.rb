class AuthorImageUploader < ApplicationUploader

  include CarrierWave::MiniMagick
  process convert: :jpg

  VERSIONS = {
    medium: 256,
    small: 128,
  }.freeze

  VERSIONS.each do |name, version_width|
    version name, &create_version(version_width)
  end

  def extension_whitelist
    %w[jpg jpeg]
  end

end
