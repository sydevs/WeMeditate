module Admin
  class UsersController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model User
    end

    def create
      super user_params
    end

    def update
      super user_params
    end

    private
      def user_params
        params.fetch(:user, {}).permit(:email, :role, languages: [])
      end

  end
end
