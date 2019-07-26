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

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[png jpg jpeg]
  end

end
