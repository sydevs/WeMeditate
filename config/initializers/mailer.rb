=begin
Rails.application.configure do
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.zoho.eu',
    port: 587,
    user_name: ENV['SMTP_EMAIL'],
    password: ENV['SMTP_PASSWORD'],
    domain: 'love-america.us',
    authentication: :plain,
    #ssl: true,
    #tls: true,
    #openssl_verify_mode: 'none',
    enable_starttls_auto: true,
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_options = { from: ENV['SMTP_EMAIL'] }
  config.action_mailer.raise_delivery_errors = true
end
=end
