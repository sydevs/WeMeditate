
RouteTranslator.config do |config|
  config.locale_param_key = :locale
  config.hide_locale = true
  config.verify_host_path_consistency = true

  if Rails.env.production?
    Rails.configuration.admin_url = 'http://admin.wemeditate.co'
    config.host_locales = {
      'www.wemeditate.co' => :en, # English
      'www.wemeditate.ru' => :ru, # Russian
      'www.wemeditate.it' => :it, # Italian
      'www.wemeditate.fr' => :fr, # French
      'de.wemeditate.co' => :de, # German
      'es.wemeditate.co' => :es, # Spanish
      'pt.wemeditate.co' => :pt, # Portuguese
      'nl.wemeditate.co' => :nl, # Dutch
      'am.wemeditate.co' => :hy, # Armenian
      'ua.wemeditate.co' => :uk, # Ukrainian
    }
  else
    Rails.configuration.admin_url = 'http://admin.localhost:3000'
    config.host_locales = {}
    host = 'localhost'
    #host = 'omicron.local'

    I18n.available_locales.each do |locale|
      hostname = (locale == :en ? host : "#{locale}.#{host}")
      config.host_locales[hostname] = locale
    end
  end

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