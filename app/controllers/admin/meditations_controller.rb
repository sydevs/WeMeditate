module Admin
  class MeditationsController < Admin::ApplicationRecordController
    prepend_before_action do
      set_model Meditation
    end

    def create
      super meditation_params
    end

    def update
      super meditation_params
    end

    protected
      def set_resource
        @resource = Meditation.friendly.find(params[:id])
        @meditation = @resource
      end

    private
      def meditation_params
        result = params.fetch(:meditation, {}).permit(
          :name, :slug, :image, :video, :duration_filter_id,
          goal_filter_ids: [],
          metatags: {}
        )

        result
      end

  end
end
