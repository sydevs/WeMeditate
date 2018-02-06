module Admin
  class UsersController < Admin::ApplicationResourceController
    before_action :set_assignable_roles, only: [:index, :create, :update]
    
    prepend_before_action do
      set_model User
    end

    def create
      @user = User.new user_params
      authorize @user
      @user.invite!
      redirect_to [:admin, User]
    end

    def update
      super user_params
    end

    private
      def user_params
        params.fetch(:user, {}).permit(:email, :role, languages: [])
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
