module Admin
  class UsersController < Admin::ApplicationRecordController

    before_action :set_assignable_roles, only: %i[index new edit create update]
    prepend_before_action { @model = User }

    def create
      @record = User.new user_params
      authorize @record
      @record.valid?
      @record.errors.delete(:password)

      if @record.errors.present?
        render :edit
      else
        @record.invite!(current_user)
        redirect_to helpers.polymorphic_admin_path([:admin, User])
      end
    end

    def update
      record_params = user_params
      record_params[:languages_known].reject!(&:empty?)

      if record_params[:languages_known].present?
        # Ensure that any languages_known which are available to the edited user, and unavailable to the current editor, remain.
        record_params[:languages_known] += (@record.accessible_locales - current_user.accessible_locales)
      elsif I18n.available_locales != current_user.accessible_locales
        # Ensure that if a user is set to have all languages (aka no specified languages), then it only assigns languages available to the current editor.
        record_params[:languages_known] = current_user.accessible_locales
      end

      super record_params
      @record.invite! if params[:reinvite] == 'true'
    end

    private

      def user_params
        params.fetch(:user, {}).permit(:name, :email, :role, languages_access: [], languages_known: [])
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
