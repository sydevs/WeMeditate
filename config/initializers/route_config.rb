
RouteTranslator.config do |config|
  config.locale_param_key = :locale
  #config.generate_unnamed_unlocalized_routes = true
  config.verify_host_path_consistency = true

  if Rails.env.production?
    config.host_locales = {
      'www.wemeditate.ru' => :ru,
      'it.wemeditate.co' => :it,
      'www.wemeditate.co' => :en,
    }
  else
    config.host_locales = {}
    host = 'localhost'
    # host = 'omicron.local'

    I18n.available_locales.each do |locale|
      hostname = (locale == :en ? host : "#{locale}.#{host}")
      config.host_locales[hostname] = locale
    end
  end

  Rails.configuration.locale_hosts = config.host_locales.invert

  # TODO: See this comment for a workaround, https://github.com/enriclluelles/route_translator/issues/171#issuecomment-324083093
end

class DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.include? request.host
  end
end