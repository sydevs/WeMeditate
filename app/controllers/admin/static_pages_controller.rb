module Admin
  class StaticPagesController < Admin::ApplicationRecordController
    include HasContent, RequiresApproval

    prepend_before_action do
      set_model StaticPage
    end

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

    protected
      def static_page_params
        if policy(@record || StaticPage).update_structure?
          params.fetch(:static_page, {}).permit(
            :name, :slug, :role,
            sections_attributes: ALL_SECTION_ATTRIBUTES,
            metatags: {}
          )
        else
          params.fetch(:static_page, {}).permit(
            :name,
            sections_attributes: TRANSLATABLE_SECTION_ATTRIBUTES
          )
        end
      end

  end
end
