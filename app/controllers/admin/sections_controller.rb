module Admin
  class SectionsController < Admin::ApplicationRecordController
    before_action :set_parent, only: [:new, :create]
    prepend_before_action do
      set_model Section
    end

    def new
      @record = @parent.sections.new
      render 'admin/application/new'
    end

    def create
      @record = @parent.sections.new update_params(section_params)
      authorize @record

      if @record.save
        redirect_to [:edit, :admin, @record], flash: { notice: t('messages.result.created') }
      else
        render :new
      end
    end

    def update
      super section_params
    end

    def sort
      params[:order].each_with_index do |id, index|
        section = Section.find(id)
        section.update_attribute(:order, index)
        @parent = section.page unless @parent.present?
      end

      redirect_to [:admin, @parent]
    end

    private
      CONTENT_ATTRIBUTES = [
        :title, :subtitle, :sidetext, :text, :quote, :credit, :url, :action, # These are the options for different content_types
        extra: {}, # For extra attributes sections
      ]

      ALL_SECTION_ATTRIBUTES = [
        :id, :label, :order, :_destroy, # Meta fields
        :content_type, :visibility_type, :visibility_countries, :format, # Structural fields
      ] + CONTENT_ATTRIBUTES

      TRANSLATABLE_SECTION_ATTRIBUTES = [
        :id, :label, # Meta fields
      ] + CONTENT_ATTRIBUTES

      def section_params
        if policy(@record || Section).update_structure?
          params.fetch(:section, {}).permit(ALL_SECTION_ATTRIBUTES)
        else
          params.fetch(:section, {}).permit(TRANSLATABLE_SECTION_ATTRIBUTES)
        end
      end

      def set_parent
        if params[:article_id].present?
          @parent = Article.friendly.find(params[:article_id])
        elsif params[:static_page_id].present?
          @parent = StaticPage.friendly.find(params[:static_page_id])
        elsif params[:city_id].present?
          @parent = City.friendly.find(params[:city_id])
        elsif params[:subtle_system_node_id].present?
          @parent = SubtleSystemNode.friendly.find(params[:subtle_system_node_id])
        end
      end

  end
end
