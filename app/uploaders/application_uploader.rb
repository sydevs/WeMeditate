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

  def self.create_version version_width
    proc {
      process resize_to_limit: [version_width, nil]

      def width
        self.class::VERSIONS[version_name]
      end

      version :webp do
        process :convert_to_webp

        def full_filename _for_file
          "#{super.rpartition('.').first}.webp"
        end
      end
    }
  end

  def convert_to_webp
    manipulate! do |img|
      img.format :webp do |c|
        c.quality '90'
        c.define 'method=6'
        c.define 'webp:lossless=true' if file.content_type == 'image/png'
      end
    end
  end

  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected

    def secure_token(length = 16)
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.hex(length/2))
    end

end
