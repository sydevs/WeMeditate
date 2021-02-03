CarrierWave.configure do |config|
  config.asset_host = "https://#{ENV['GCLOUD_BUCKET']}" if ENV['GCLOUD_BUCKET']

  if ENV['GCLOUD_BUCKET'].present?
    config.storage = :fog

    config.fog_provider = 'fog/google'
    config.fog_directory = ENV['GCLOUD_BUCKET']
    config.fog_attributes = { expires: 600 }
    config.fog_credentials = {
      provider:               'Google',
      google_project:         'we-meditate',
      google_json_key_string: ENV['GOOGLE_CLOUD_KEYFILE'].present? ? ENV['GOOGLE_CLOUD_KEYFILE'] : nil,
    }
  else
    config.storage = :file
  end
end
