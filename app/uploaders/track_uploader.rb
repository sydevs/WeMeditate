# For uploading audio tracks
class TrackUploader < CarrierWave::Uploader::Base

  process :store_meta

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[mp3]
  end

  # Store width and height in model meta attribute
  def store_meta
    raise StandardError, 'Either file or model not defined when storing meta' unless file && model

    # Note: file on Heroku is CarrierWave::Storage::Fog::File but in dev it's
    # CarrierWave::SanitizedFile (whether GCLOUD_BUCKET is set or not).
    # Unfortunately don't have any explanation for the discrepancy.

    parsed_file = FFMPEG::Movie.new(file.file)
    model.duration = parsed_file.duration
  end

end
