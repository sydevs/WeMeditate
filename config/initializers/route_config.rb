RouteTranslator.config do |config|
  config.locale_param_key = :locale
  config.hide_locale = true

  if Rails.env.production?
    Rails.configuration.admin_domain = 'admin.wemeditate.com'
    Rails.configuration.admin_host = Rails.configuration.admin_domain
    Rails.configuration.locale_hosts = {
      :'pt-br' => 'br.wemeditate.com', # Brazilian Portuguese
      fr: 'wemeditate.fr', # French
      cs: 'wemeditate.cz', # Czech
      it: 'wemeditate.it', # Italian
      ru: 'wemeditate.ru', # Russian
      en: 'wemeditate.com', # English
    }

    I18n.available_locales.each do |locale|
      return if Rails.configuration.locale_hosts.key?(locale)

      Rails.configuration.locale_hosts[locale] = "#{locale}.wemeditate.com"
    end

    config.host_locales = locale_hosts.invert
    config.host_locales.reverse_merge!({
      'wemeditate.co.uk' => :en
    })
  elsif Rails.env.staging?
    Rails.configuration.admin_domain = 'admin.staging-wemeditate.com'
    Rails.configuration.admin_host = Rails.configuration.admin_domain
    config.host_locales = {}

    I18n.available_locales.each do |locale|
      hostname = "#{locale}.staging-wemeditate.com"
      config.host_locales[hostname] = locale
    end
  else
    host = ENV.fetch('LOCALHOST')
    Rails.configuration.admin_domain = "admin.#{host}"
    Rails.configuration.admin_host = "#{Rails.configuration.admin_domain}:3000"
    config.host_locales = {}

    I18n.available_locales.each do |locale|
      hostname = (locale == :en ? host : "#{locale.downcase}.#{host}")
      config.host_locales[hostname] = locale
    end
  end

  Rails.configuration.admin_url = "http://#{Rails.configuration.admin_domain}"
  Rails.configuration.locale_hosts = config.host_locales.invert
end

class DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.include? request.host
  end
end
