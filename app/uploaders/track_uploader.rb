# For uploading audio tracks
class TrackUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[mp3]
  end

end
