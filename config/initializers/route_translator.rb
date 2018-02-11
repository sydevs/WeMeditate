
RouteTranslator.config do |config|
  config.locale_param_key = :locale

  RouteTranslator.config.host_locales = {
      '*.ru' => :ru,
      '*'    => :en,
  }
end
