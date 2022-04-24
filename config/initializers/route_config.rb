RouteTranslator.config do |config|
  config.locale_param_key = :locale

  if Rails.env.production?
    Rails.configuration.public_domain = 'wemeditate.com'
    Rails.configuration.public_host = Rails.configuration.public_domain
    Rails.configuration.admin_domain = 'admin.wemeditate.com'
    Rails.configuration.admin_host = Rails.configuration.admin_domain
  elsif Rails.env.staging?
    Rails.configuration.public_domain = 'staging.wemeditate.com'
    Rails.configuration.public_host = Rails.configuration.public_domain
    Rails.configuration.admin_domain = 'admin.staging.wemeditate.com'
    Rails.configuration.admin_host = Rails.configuration.admin_domain
  else
    host = ENV.fetch('LOCALHOST')
    Rails.configuration.public_domain = host
    Rails.configuration.public_host = "#{host}:3000"
    Rails.configuration.admin_domain = "admin.#{host}"
    Rails.configuration.admin_host = "#{Rails.configuration.admin_domain}:3000"
  end

  Rails.configuration.admin_url = "http://#{Rails.configuration.admin_domain}"
end

class DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.include? request.host
  end
end
