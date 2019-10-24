Rails.application.configure do
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    user_name: ENV['SMTP_EMAIL'],
    password: ENV['SMTP_PASSWORD'],
    domain: 'wemeditate.co',
    authentication: :plain,
    enable_starttls_auto: true,
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_options = { from: "#{I18n.translate 'we_meditate'} <#{ENV['SMTP_EMAIL']}>" }
  config.action_mailer.raise_delivery_errors = true
end

unless Rails.env.production?
  class EmailEnvironmentLabeler
    def self.delivering_email(mail)
      mail.subject.prepend("[WM/#{Rails.env}] ")
    end
  end
  
  ActionMailer::Base.register_interceptor(EmailEnvironmentLabeler)
end