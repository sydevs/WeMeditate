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
      # Default to the existing name if no new name is set.
      params = author_params
      params[:name] ||= @record.name || @record.get_native_locale_attribute(:name, @record.original_locale)
      super params
    end

    private

      def author_params
        if policy(@author || Author).update_structure?
          params.fetch(:author, {}).permit(:name, :state, :country_code, :title, :description, :image, :years_meditating, :user_id)
        else
          params.fetch(:author, {}).permit(:state, :title, :description)
        end
      end

  end
end
