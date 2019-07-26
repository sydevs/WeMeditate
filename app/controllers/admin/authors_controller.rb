module Admin
  class AuthorsController < Admin::ApplicationRecordController

    prepend_before_action { @model = Author }

    def new
      @record = @model.new user: (current_user if params[:self])
      render 'admin/application/new'
    end

    def create
      super author_params
    end

    def update
      super author_params
    end

    private

      def author_params
        if policy(@author || Author).update_structure?
          params.fetch(:author, {}).permit(:name, :country_code, :title, :description, :image, :years_meditating, :user_id)
        else
          params.fetch(:author, {}).permit(:title, :description)
        end
      end

  end
end
