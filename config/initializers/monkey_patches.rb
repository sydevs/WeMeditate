# Monkey patch the carrierwave-google-storage gem to include assets version
# for URL's. Was added in July 2021 to bust a hidden cache within Google Cloud
# Storage which prevented CORS headers from appearing.

module GcloudUrlWithAssetVersionQueryString

  # The handle_options method gets called by all methods setting and deleting cookies
  def public_url
    "#{super}?version=#{Rails.application.config.assets.version}"
  end

end

CarrierWave::Storage::GcloudFile.prepend GcloudUrlWithAssetVersionQueryString
