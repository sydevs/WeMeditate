module Admin
  class StaticPagesController < Admin::ApplicationRecordController

    prepend_before_action { @model = StaticPage }

    def new
      @record = @model.new role: params[:role]
      render 'admin/application/new'
    end

    def create
      super static_page_params
    end

    def update
      super static_page_params
    end

    protected

      def static_page_params
        allow = policy(@record || StaticPage)
        if (allow.create? && action_name == 'create') || allow.update_structure?
          params.fetch(:static_page, {}).permit(:state, :name, :slug, :role, :content, metatags: {})
        else
          params.fetch(:static_page, {}).permit(:state, :name, :slug, :content)
        end
      end

  end
end
