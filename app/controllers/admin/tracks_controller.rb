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
        if policy(@track || Track).publish?
          params.fetch(:track, {}).permit(
            :name, :audio, :published,
            artist_ids: [], mood_filter_ids: [], instrument_filter_ids: []
          )
        else
          params.fetch(:track, {}).permit(
            :name, :audio,
            artist_ids: [], mood_filter_ids: [], instrument_filter_ids: []
          )
        end
      end

  end
end
