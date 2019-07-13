module Admin
  class SubtleSystemNodesController < Admin::ApplicationRecordController

    prepend_before_action { @model = SubtleSystemNode }

    def create
      super subtle_system_node_params
    end

    def update
      super subtle_system_node_params
    end

    protected

      def subtle_system_node_params
        allow = policy(@record || SubtleSystemNode)
        if (allow.create? && action_name == 'create') || allow.update_structure?
          params.fetch(:subtle_system_node, {}).permit(:name, :slug, :excerpt, :role, :content, metatags: {})
        else
          params.fetch(:subtle_system_node, {}).permit(:name, :excerpt)
        end
      end

  end
end
