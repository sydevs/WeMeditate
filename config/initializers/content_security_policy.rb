# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  gtm_sources = %w[www.googletagmanager.com tagmanager.google.com www.google-analytics.com]

  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, ApplicationUploader.asset_host || '', *gtm_sources, :https, :data
  policy.object_src  :none
  policy.script_src  :self, *gtm_sources, :unsafe_eval, :unsafe_inline, :https
  policy.style_src   :self, :unsafe_inline, :https
  policy.frame_src   :self, 'player.vimeo.com', 'player.twitch.tv', ENV['ATLAS_URL'] || ''

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
# Rails.application.config.content_security_policy_report_only = true
