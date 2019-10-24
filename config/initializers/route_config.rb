
RouteTranslator.config do |config|
  config.locale_param_key = :locale
  config.hide_locale = true
  config.verify_host_path_consistency = true

  if Rails.env.production?
    Rails.configuration.admin_url = 'http://admin.wemeditate.co'
    config.host_locales = {
      'ua.wemeditate.co' => :uk, # Ukrainian
      'am.wemeditate.co' => :hy, # Armenian
      'nl.wemeditate.co' => :nl, # Dutch
      'pt.wemeditate.co' => :pt, # Portuguese
      'es.wemeditate.co' => :es, # Spanish
      'de.wemeditate.co' => :de, # German
      'www.wemeditate.fr' => :fr, # French
      'www.wemeditate.it' => :it, # Italian
      'www.wemeditate.ru' => :ru, # Russian
      'www.wemeditate.co.uk' => :en, # English
      'www.wemeditate.co' => :en, # English
    } # Domains at the bottom of the list have highest priority.
  elsif Rails.env.staging?
    Rails.configuration.admin_url = 'http://admin.staging.wemeditate.co'
    config.host_locales = {}

    I18n.available_locales.each do |locale|
      hostname = "#{locale}.staging.wemeditate.co"
      config.host_locales[hostname] = locale
    end
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