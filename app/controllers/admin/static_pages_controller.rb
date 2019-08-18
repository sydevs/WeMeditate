module Admin
  class StaticPagesController < Admin::ApplicationRecordController

    prepend_before_action { @model = StaticPage }

    def create
      super static_page_params
    end

    def update
      super static_page_params
    end

    def write
      @splash_style = @record.role.to_sym if @record.home?
    end

    protected

      def static_page_params
        allow = policy(@record || StaticPage)
        if (allow.create? && action_name == 'create') || allow.update_structure?
          params.fetch(:static_page, {}).permit(:name, :slug, :role, :content, metatags: {})
        else
          params.fetch(:static_page, {}).permit(:name, :content)
        end
      end

  end
end
