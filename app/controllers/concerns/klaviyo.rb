require 'httparty'

## KLAVIYO
# This concern simplifies requests to Klaviyo

module Klaviyo

  def self.subscribe email
    return unless ENV['KLAVIYO_API_KEY'].present?
    raise ArgumentError, "No newsletter ID has been defined." unless ENV['KLAVIYO_LIST_ID'].present?

    Klaviyo.request("api/v2/list/#{ENV['KLAVIYO_LIST_ID']}/subscribe", {
      'api_key': ENV['KLAVIYO_API_KEY'],
      'profiles': [{
        'email': email,
        '$consent': 'email',
      }],
    })
  end

  private
  
    def self.request path, request_params
      HTTParty.post("https://a.klaviyo.com/#{path}", {
        body: request_params.to_json,
        headers: {
          'Content-Type': 'application/json'
        }
      })
    end

end
