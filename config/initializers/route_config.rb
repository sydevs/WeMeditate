
RouteTranslator.config do |config|
  config.locale_param_key = :locale
  #config.generate_unnamed_unlocalized_routes = true
  config.verify_host_path_consistency = true

  config.host_locales = {
    'www.wemeditate.ru' => :ru,
    'it.wemeditate.co' => :it,
    'www.wemeditate.co' => :en,
  }

  if Rails.env.development?
    I18n.available_locales.each do |locale|
      config.host_locales["#{locale}.localhost"] = locale
      config.host_locales["#{locale}.omicron.local"] = locale
    end

    config.host_locales['localhost'] = :en
  end

  # TODO: See this comment for a workaround, https://github.com/enriclluelles/route_translator/issues/171#issuecomment-324083093
end

class DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.include? request.domain
  end
end