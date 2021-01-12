class ApplicationUploader < CarrierWave::Uploader::Base

  storage ENV['GCLOUD_BUCKET'].present? ? :gcloud : :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  # A helper method which is used by various uploaders to generate a standard version of the image.
  def self.create_version version_width
    proc {
      process resize_to_limit: [version_width, nil]

      # We need to be able to access the version's width so that we can provide that info to browsers to let them select the best version for the screen size.
      def width
        self.class::VERSIONS[version_name]
      end

      # All images on the site are converted to WEBP, as most browsers now support this more efficient image format.
      version :webp do
        process :convert_to_webp

        def full_filename _for_file
          "#{super.rpartition('.').first}.webp"
        end
      end
    }
  end

  # Helper functiion to convert an image to WEBP
  def convert_to_webp
    manipulate! do |img|
      img.format :webp do |c|
        c.quality '90'
        c.define 'method=6'
        c.define 'webp:lossless=true' if file.content_type == 'image/png'
      end
    end
  end

  # Replace all file names with a unique random string
  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  def to_json _obj
    if self.class::VERSIONS.present?
      {
        url: url,
        type: file.extension,
        versions: self.class::VERSIONS.map { |key, width| { width: width, url: url(key) } },
      }
    else
      { url: url }
    end
  end

  protected

    # This checks if a secure token already exists for this file, and otherwise generates a new one.
    def secure_token(length = 16)
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.hex(length / 2))
    end

end
