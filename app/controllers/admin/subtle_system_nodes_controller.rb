module Admin
  class SubtleSystemNodesController < Admin::ApplicationPageController
    prepend_before_action do
      set_model SubtleSystemNode
    end

    def new
      @page = SubtleSystemNode.new role: params[:role]
      @page.generate_default_sections!
      set_instance_variable
    end

    def edit
      super
    end

    def create
      super subtle_system_node_params
    end

    def update
      super subtle_system_node_params
    end

    protected
      def subtle_system_node_params
        if policy(@subtle_system_node || SubtleSystemNode).update_structure?
          params.fetch(:subtle_system_node, {}).permit(
            :name, :slug, :excerpt, :role,
            sections_attributes: Admin::ApplicationPageController::ALL_SECTION_ATTRIBUTES
          )
        else
          params.fetch(:subtle_system_node, {}).permit(
            :name, :excerpt,
            sections_attributes: Admin::ApplicationPageController::TRANSLATABLE_SECTION_ATTRIBUTES
          )
        end
      end

  end
end
