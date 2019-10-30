if Rails.env.development?
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfiler.config.position = 'bottom-left'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
