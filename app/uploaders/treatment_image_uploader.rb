class TreatmentImageUploader < ImageUploader

  include CarrierWave::MiniMagick

  VERSIONS = {
    medium: 500,
    small: 200,
  }.freeze

  VERSIONS.each do |name, version_width|
    version name, &create_version(version_width)
  end

end
