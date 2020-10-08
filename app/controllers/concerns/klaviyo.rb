require 'httparty'

## KLAVIYO
# This concern simplifies requests to Klaviyo

module Klaviyo

  module Event
    REALISATION_COMPLETED = "Self-Realisation Completed"
  end

  def self.subscribe email, list_id, referer
    return unless ENV['KLAVIYO_API_KEY'].present?

    list_id = ENV['KLAVIYO_LIST_ID'] unless list_id.present?
    raise ArgumentError, 'No newsletter ID has been defined.' unless list_id.present?

    Klaviyo.request("api/v2/list/#{list_id}/subscribe", {
      'api_key': ENV['KLAVIYO_API_KEY'],
      'profiles': [{
        'email': email,
        '$consent': 'email',
        'referer': referer,
      }],
    })
  end

  def self.track email, event, properties
    return unless ENV['KLAVIYO_API_KEY'].present?

    Klaviyo.request('api/track', {
      'token': ENV['KLAVIYO_API_KEY'],
      'event': event,
      'customer_properties' : {
        '$email' : email,
      },
      'properties': properties,
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
