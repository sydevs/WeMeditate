module Admin
  # Basic controller that all other admin controllers inherit from.
  class ApplicationController < ::ApplicationController

    prepend_before_action :set_locale!
    before_action :authenticate_user!
    before_action :redirect_to_locale!
    after_action :verify_authorized, except: %i[dashboard vimeo_data error]
    after_action :verify_policy_scoped, only: :index
    layout 'admin/application'

    def dashboard
      localize :content do
        authorize :application, :access?
        render 'admin/special/dashboard'
      end
    end

    def tutorial
      authorize :application, :access?
      render 'admin/special/tutorial'
    end

    def error
      render status: request.env['PATH_INFO'][1, 3].to_i
      render 'admin/special/error'
    end

    def vimeo_data
      render json: Vimeo.retrieve_metadata(params[:vimeo_id])
    end

    protected

      def default_url_options options = {}
        { locale: Globalize.locale, host: Rails.configuration.public_host }.merge(options)
      end

      def localize mode
        if mode == :interface
          with_cleared_url_options_cache do
            I18n.with_locale(I18n.locale) do
              Globalize.with_locale(Globalize.locale) do
                yield
              end
            end
          end
        elsif mode == :content
          with_cleared_url_options_cache do
            Globalize.with_locale(Globalize.locale) do
              yield
            end
          end
        end
      end

    private

      def set_locale!
        I18n.locale = current_user&.preferred_language&.to_sym || :en
        Globalize.locale = params[:locale]&.dasherize&.to_sym || :en
        Rails.application.routes.default_url_options[:host] = Rails.configuration.public_host
        Rails.application.routes.default_url_options[:locale] = Globalize.locale.to_s.underscore
      end

      def redirect_to_locale!
        return if current_user.accessible_locales.include?(Globalize.locale)

        redirect_to admin_root_path(locale: current_user.accessible_locales.first), status: :see_other
      end

      # Read more: https://github.com/rails/rails/issues/26040#issuecomment-574112746
      def with_cleared_url_options_cache
        # So e.g. a changed locale within the block affects default_url_options.
        instance_variable_set("@_url_options", nil)
        yield
      ensure
        # So that any changes e.g. to locale within the block don't leak outside the block.
        instance_variable_set("@_url_options", nil)
      end

  end
end
