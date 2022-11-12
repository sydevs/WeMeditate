# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

return if Rails.env.development?

Rails.application.configure do
  config.content_security_policy do |policy|
    asset_host = CarrierWave::Uploader::Base.asset_host
    gtm_sources = %w[www.googletagmanager.com tagmanager.google.com www.google-analytics.com stats.g.doubleclick.net www.gstatic.com]
    jwp_sources = %w[cdn.jwplayer.com ssl.p.jwpcdn.com videos-cloudflare.jwpsrv.com assets-jpcust.jwpsrv.com prd.jwpltx.com]
    vimeo_sources = %w[player.vimeo.com vod-progressive.akamaized.net]
    atlas_sources = %w[atlas.sydevelopers.com api.mapbox.com events.mapbox.com]
    fathom_sources = %w[thirtyeight-code.wemeditate.com]
    featured_stream_sources = %w[gist.githubusercontent.com cdn.jsdelivr.net]

    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, asset_host, *gtm_sources, *jwp_sources, :https, :data
    policy.object_src  :none
    policy.script_src  :self, *gtm_sources, *jwp_sources, :unsafe_eval, :unsafe_inline, :https
    policy.worker_src  :self, :blob
    policy.connect_src :self, asset_host, *fathom_sources, *featured_stream_sources, *gtm_sources, *jwp_sources, *atlas_sources
    policy.media_src   :blob, asset_host, 'cdn.jwplayer.com', 'player.twitch.tv', 'www.youtube.com', *vimeo_sources
    policy.style_src   :self, :unsafe_inline, :https
    policy.frame_src   :self, 'atlas.sydevelopers.com', 'cdn.jwplayer.com', 'player.twitch.tv', 'www.youtube.com', 'www.google.com', 'www.recaptcha.net', *vimeo_sources

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Set the nonce only to specific directives
  config.content_security_policy_nonce_directives = %w[]

  # Report CSP violations to a specified URI
  # For further information see the following documentation:
  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
  config.content_security_policy_report_only = Rails.env.development?
end
