module Admin
  # Basic controller that all other admin controllers inherit from.
  class ApplicationController < ::ApplicationController

    before_action :authenticate_user!
    before_action :redirect_to_locale!
    after_action :verify_authorized, except: %i[dashboard vimeo_data error]
    after_action :verify_policy_scoped, only: :index

    def dashboard
      authorize :application, :access?
    end

    def tutorial
      authorize :application, :access?
    end

    def error
      render status: request.env['PATH_INFO'][1, 3].to_i
    end
    
    def vimeo_data
      render json: Vimeo.retrieve_metadata(params[:vimeo_id])
    end

    protected

      def default_url_options
        { locale: I18n.locale, host: locale_host }
      end

    private

      def redirect_to_locale!
        return if current_user.accessible_locales.include?(I18n.locale)

        redirect_to root_path(locale: current_user.accessible_locales.first), status: :see_other
      end

  end
end
