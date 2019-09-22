module Admin
  # Basic controller that all other admin controllers inherit from.
  class ApplicationController < ::ApplicationController

    before_action :authenticate_user!
    after_action :verify_authorized, except: %i[dashboard vimeo_data]
    after_action :verify_policy_scoped, only: :index

    def dashboard
      authorize '', :access?
    end

    def tutorial
      authorize '', :access?
    end
    
    def vimeo_data
      render json: retrieve_vimeo_data(params[:vimeo_id])
    end

    protected

      def default_url_options
        { locale: I18n.locale, host: locale_host }
      end

    private

      def self.policy_class
        ApplicationPolicy
      end

      def retrieve_vimeo_data vimeo_id
        Integer(vimeo_id) rescue raise ArgumentError, "Vimeo ID is not valid: \"#{vimeo_id}\""
        raise 'Vimeo Access Key has not been set' unless ENV['VIMEO_ACCESS_KEY'].present?

        uri = URI("https://api.vimeo.com/videos/#{vimeo_id}?fields=name,pictures.sizes")
        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{ENV['VIMEO_ACCESS_KEY']}"
      
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end
      
        response = JSON.parse(response.body)
      
        return {
          vimeo_id: vimeo_id,
          title: response['name'],
          thumbnail: response['pictures']['sizes'].last['link'],
          thumbnail_srcset: response['pictures']['sizes'].map { |pic| "#{pic['link']} #{pic['width']}w" }.join(','),
        }
      end

  end
end
