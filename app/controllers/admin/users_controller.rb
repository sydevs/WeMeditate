module Admin
  class UsersController < Admin::ApplicationController
    before_action :set_user, except: [:index, :create]

    def index
      @users = User.all
    end

    def create
      @user = User.invite! user_params
      if @user.errors.empty?
        redirect_to [:admin, User]
      else
        redirect_to [:admin, User], alert: @user.errors.messages
      end
    end

    def update
      @user.update user_params
      #head :ok
      redirect_to [:admin, User]
    end

    def destroy
      @user.destroy #if @category.documents.count == 0
      redirect_to [:admin, User]
    end

    private
      def user_params
        params.fetch(:user, {}).permit(:email)
      end

      def set_user
        @user = User.find(params[:id])
      end

  end
end
