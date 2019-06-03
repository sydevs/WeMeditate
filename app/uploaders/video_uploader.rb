class VideoUploader < CarrierWave::Uploader::Base

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[mp4]
  end

end
