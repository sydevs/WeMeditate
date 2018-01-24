module Admin
  class UsersController < Admin::ApplicationController
    before_action :set_user, except: [:index, :create]
    before_action :authorize!, except: [:create]

    def index
      @users = User.order(:email).all
    end

    def create
      @user = User.new user_params
      authorize @user
      @user.invite!

      if @user.errors.empty?
        redirect_to [:admin, User]
      else
        redirect_to [:admin, User], alert: @user.errors.messages
      end
    end

    def update
      if @user.update user_params
        head :ok
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    def destroy
      @user.destroy #if @category.documents.count == 0
      redirect_to [:admin, User]
    end

    private
      def user_params
        params.fetch(:user, {}).permit(:email, :role, languages: [])
      end

      def set_user
        @user = User.find(params[:id])
      end

      def authorize!
        authorize @user || User
      end

  end
end
