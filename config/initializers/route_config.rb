RouteTranslator.config do |config|
  config.locale_param_key = :locale
  config.hide_locale = true

  if Rails.env.production?
    Rails.configuration.admin_domain = 'admin.wemeditate.com'
    Rails.configuration.admin_host = Rails.configuration.admin_domain
    config.host_locales = {
      'am.wemeditate.com' => :hy, # Armenian
      'bg.wemeditate.com' => :bg, # Bulgarian
      'br.wemeditate.com' => :'pt-br', # Brazilian Portuguese
      'de.wemeditate.com' => :de, # German
      'el.wemeditate.com' => :el, # Greek
      'es.wemeditate.com' => :es, # Spanish
      'fa.wemeditate.com' => :fa, # Farsi
      'hi.wemeditate.com' => :hi, # Hindi
      'hy.wemeditate.com' => :hy, # Armenian
      'nl.wemeditate.com' => :nl, # Dutch
      'ro.wemeditate.com' => :ro, # Romanian
      'se.wemeditate.com' => :sv, # Swedish
      'tr.wemeditate.com' => :tr, # Turkish
      'ua.wemeditate.com' => :uk, # Ukrainian

      'wemeditate.fr' => :fr, # French
      'wemeditate.cz' => :cs, # Czech
      'wemeditate.it' => :it, # Italian
      'wemeditate.ru' => :ru, # Russian
      'wemeditate.co.uk' => :en, # English
      'wemeditate.com' => :en, # English
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
