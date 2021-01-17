RouteTranslator.config do |config|
  config.locale_param_key = :locale
  config.hide_locale = true

  if Rails.env.production?
    Rails.configuration.admin_domain = 'admin.wemeditate.co'
    Rails.configuration.admin_host = Rails.configuration.admin_domain
    config.host_locales = {
      'fa.wemeditate.co' => :fa, # Farsi
      'ua.wemeditate.co' => :uk, # Ukrainian
      'am.wemeditate.co' => :hy, # Armenian
      'nl.wemeditate.co' => :nl, # Dutch
      'es.wemeditate.co' => :es, # Spanish
      'de.wemeditate.co' => :de, # German
      'br.wemeditate.co' => :'pt-br', # Brazilian Portuguese
      'ro.wemeditate.co' => :ro, # Romanian
      'hy.wemeditate.co' => :hy, # Armenian
      'hi.wemeditate.co' => :hi, # Hindi
      'tr.wemeditate.co' => :tr, # Turkish
      'se.wemeditate.co' => :sv, # Swedish
      'bg.wemeditate.co' => :bg, # Bulgarian
      'wemeditate.fr' => :fr, # French
      'wemeditate.cz' => :cs, # Czech
      'wemeditate.it' => :it, # Italian
      'wemeditate.ru' => :ru, # Russian
      'wemeditate.co.uk' => :en, # English
      'wemeditate.co' => :en, # English
    } # Domains at the bottom of the list have highest priority.
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
