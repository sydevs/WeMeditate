module Admin
  # Basic controller that all other admin controllers inherit from.
  class ApplicationController < ::ApplicationController

    before_action :authenticate_user!
    before_action :redirect_to_locale!
    after_action :verify_authorized, except: %i[dashboard vimeo_data]
    after_action :verify_policy_scoped, only: :index

    def dashboard
      authorize :application, :access?
    end

    def tutorial
      authorize :application, :access?
    end
    
    def vimeo_data
      render json: retrieve_vimeo_data(params[:vimeo_id])
    end

    protected

      def default_url_options
        { locale: I18n.locale, host: locale_host }
      end

    private

      def retrieve_vimeo_data vimeo_id
        Integer(vimeo_id) rescue raise ArgumentError, "Vimeo ID is not valid: \"#{vimeo_id}\""
        raise 'Vimeo Access Key has not been set' unless ENV['VIMEO_ACCESS_KEY'].present?

        uri = URI("https://api.vimeo.com/videos/#{vimeo_id}?fields=name,width,height,pictures.sizes,download.link,duration,link")
        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{ENV['VIMEO_ACCESS_KEY']}"
      
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end
      
        response = JSON.parse(response.body)
        puts "Retrieved Vimeo Data for #{vimeo_id}\r\n#{response.pretty_inspect}"
      
        return {
          vimeo_id: vimeo_id,
          title: response['name'],
          thumbnail: response['pictures']['sizes'].last['link'],
          thumbnail_srcset: response['pictures']['sizes'].map { |pic| "#{pic['link']} #{pic['width']}w" }.join(','),
          download_url: (response['download'][0]['link'] if response['download'].present?),
          embed_url: response['link'],
          duration: ActiveSupport::Duration.build(response['duration']).iso8601,
        }
      end

      def redirect_to_locale!
        return if current_user.available_languages.include?(I18n.locale)

        redirect_to root_path(locale: current_user.available_languages.first)
      end

  end
end
