module Admin
  class UsersController < Admin::ApplicationRecordController

    before_action :set_assignable_roles, only: %i[index new edit create update]
    prepend_before_action { @model = User }

    def create
      @record = User.new user_params
      authorize @record
      @record.invite!(current_user)
      redirect_to helpers.polymorphic_admin_path([:admin, User])
    end

    def update
      record_params = user_params
      record_params[:languages].reject!(&:empty?)

      if record_params[:languages].present?
        # Ensure that any languages which are available to the edited user, and unavailable to the current editor, remain.
        record_params[:languages] += (@record.available_languages - current_user.available_languages)
      elsif I18n.available_locales != current_user.available_languages
        # Ensure that if a user is set to have all languages (aka no specified languages), then it only assigns languages available to the current editor.
        record_params[:languages] = current_user.available_languages
      end

      super record_params
    end

    private

      def user_params
        params.fetch(:user, {}).permit(:name, :email, :role, languages: [])
      end

      def set_assignable_roles
        case current_user.role
        when :super_admin.to_s
          @assignable_roles = User.roles
        when :regional_admin.to_s
          @assignable_roles = User.roles.except(:super_admin, :regional_admin)
        else
          @assignable_roles = []
        end
      end

  end
end
