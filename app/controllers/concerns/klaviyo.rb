require 'uri'
require 'net/http'

## KLAVIYO CONCERN
# This concern simplifies requests to Klaviyo

module Klaviyo

  extend ActiveSupport::Concern

  included do |base|
    # Do nothing for now
  end

  def subscribe email
    return unless ENV['KLAVIYO_API_KEY'].present?
    raise ArgumentError, "No newsletter ID has been defined." unless ENV['KLAVIYO_LIST_ID'].present?

    klaviyo_request("/api/v2/list/#{ENV['KLAVIYO_LIST_ID']}/subscribe", {
      'api_key' => ENV['KLAVIYO_API_KEY'],
      'profiles' => [{ email: email }],
      '$consent' => 'email',
    })
  end

  private
  
    def klaviyo_request path, params
      params = DEFAULT_PARAMS.merge(params)
      url = URI.parse("https://a.klaviyo.com/#{path}")
      request = Net::HTTP.post_form(url, params)
      request.body
    end

end
