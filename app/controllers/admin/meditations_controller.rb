module Admin
  class MeditationsController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model Meditation
    end

    def create
      super meditation_params
    end

    def update
      super meditation_params
    end

    private
      def meditation_params
        params.fetch(:meditation, {}).permit(:name, :file, :duration_filter_id, goal_filter_ids: [])
      end

  end
end
