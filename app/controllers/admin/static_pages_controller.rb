module Admin
  class StaticPagesController < Admin::ApplicationRecordController

    prepend_before_action { @model = StaticPage }

    def new
      @record = StaticPage.new role: params[:role]
      @record.generate_required_sections!
    end

    def edit
      @record.generate_required_sections!
      super
    end

    def create
      super static_page_params
    end

    def update
      super static_page_params
    end

    def write
      @splash_style = @record.role.to_sym if @record.home? or @record.treatments?
    end

    protected

      def static_page_params
        if policy(@record || StaticPage).update_structure?
          params.fetch(:static_page, {}).permit(:name, :slug, :role, :content, metatags: {})
        else
          params.fetch(:static_page, {}).permit(:name)
        end
      end

  end
end
