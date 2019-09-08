require 'uri'
require 'net/http'
require 'net/https'

## KLAVIYO
# This concern simplifies requests to Klaviyo

module Klaviyo

  def self.subscribe email
    return unless ENV['KLAVIYO_API_KEY'].present?
    raise ArgumentError, "No newsletter ID has been defined." unless ENV['KLAVIYO_LIST_ID'].present?

    Klaviyo.request("/api/v2/list/#{ENV['KLAVIYO_LIST_ID']}/subscribe", {
      'api_key' => ENV['KLAVIYO_API_KEY'],
      'profiles' => [{ 'email' => email }],
      '$consent' => 'email',
    })
  end

  private
  
    def self.request path, params
      puts "PARAMS #{params}"
      url = URI.parse("https://a.klaviyo.com/#{path}")
      https = Net::HTTP.new(url.host)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      https.ssl_version = OpenSSL::SSL::OP_NO_SSLv3

      # request = Net::HTTP::Post.new(url.path) 
      # request.set_form_data(params)

      # response = https.request(request)
      puts url.path.inspect
      puts params.to_json.inspect
      response = https.post(url.path, params.to_json)
      puts response.inspect
      puts "STATUS #{response.code}"
      response.body
    end

end
