class ImageUploader < ApplicationUploader

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
=begin
    version name do
      process resize_to_limit: [version_width, nil]

      def width
        VERSIONS[version_name]
      end

      version :webp do
        process :convert_to_webp

        def full_filename _for_file
          "#{super.rpartition('.').first}.webp"
        end
      end
    end
=end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[png jpg jpeg]
  end

end
