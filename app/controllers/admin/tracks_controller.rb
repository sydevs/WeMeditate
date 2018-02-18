module Admin
  class TracksController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model Track
    end

    def create
      super track_params
    end

    def update
      super track_params
    end

    private
      def track_params
        params.fetch(:track, {}).permit(:title, :subtitle, :audio, mood_filter_ids: [], instrument_filter_ids: [])
      end

  end
end
