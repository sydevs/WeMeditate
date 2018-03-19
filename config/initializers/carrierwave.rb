CarrierWave.configure do |config|
  config.storage                             = :gcloud
  config.gcloud_bucket                       = 'your-bucket-name'
  config.gcloud_bucket_is_public             = true
  config.gcloud_authenticated_url_expiration = 600
  
  config.gcloud_attributes = {
    expires: 600
  }
  
  config.gcloud_credentials = {
    gcloud_project: 'we-meditate',
    gcloud_keyfile: "#{Rails.root}/config/initializers/carrierwave.json"
  }
end
