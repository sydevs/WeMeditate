# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

return if Rails.env.development?

Rails.application.config.content_security_policy do |policy|
  gtm_sources = %w[www.googletagmanager.com tagmanager.google.com www.google-analytics.com stats.g.doubleclick.net www.gstatic.com]
  jwp_sources = %w[cdn.jwplayer.com ssl.p.jwpcdn.com videos-cloudflare.jwpsrv.com assets-jpcust.jwpsrv.com prd.jwpltx.com]
  vimeo_sources = %w[player.vimeo.com vod-progressive.akamaized.net]
  mapbox_sources = %w[api.mapbox.com]
  featured_stream_sources = %[gist.githubusercontent.com cdn.jsdelivr.net]
  # jwp_sources = []

  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, ApplicationUploader.asset_host, *gtm_sources, *jwp_sources, :https, :data
  policy.object_src  :none
  policy.script_src  :self, *gtm_sources, *jwp_sources, :unsafe_eval, :unsafe_inline, :https
  policy.worker_src  :self, :blob
  policy.connect_src :self, ApplicationUploader.asset_host, *featured_stream_sources, *gtm_sources, *jwp_sources, *mapbox_sources
  policy.media_src   :blob, ApplicationUploader.asset_host, 'cdn.jwplayer.com', 'player.twitch.tv', 'www.youtube.com', *vimeo_sources
  policy.style_src   :self, :unsafe_inline, :https
  policy.frame_src   :self, 'cdn.jwplayer.com', 'player.twitch.tv', 'www.youtube.com', 'www.google.com', 'www.recaptcha.net', *vimeo_sources, ENV['ATLAS_URL'] || ''

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> (_request) { SecureRandom.base64(16) }

# Set the nonce only to specific directives
Rails.application.config.content_security_policy_nonce_directives = %w[]

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
Rails.application.config.content_security_policy_report_only = Rails.env.development?
