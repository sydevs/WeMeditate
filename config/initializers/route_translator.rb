
RouteTranslator.config do |config|
  config.locale_param_key = :locale
  config.generate_unnamed_unlocalized_routes = true
  
  #config.verify_host_path_consistency = true

  #RouteTranslator.config.host_locales = {
  #  '*.ru' => :ru,
  #  '*'    => :en,
  #}

  # TODO: See this comment for a workaround, https://github.com/enriclluelles/route_translator/issues/171#issuecomment-324083093
end
