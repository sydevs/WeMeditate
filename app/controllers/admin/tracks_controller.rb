module Admin
  class TracksController < Admin::ApplicationRecordController

    prepend_before_action { @model = Track }

    def create
      super track_params
    end

    def update
      super track_params
    end

    private

      def track_params
        params.fetch(:track, {}).permit(
          :name, :audio, :artist_id,
          mood_filter_ids: [], instrument_filter_ids: []
        )
      end

  end
end
