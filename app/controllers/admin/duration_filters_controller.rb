module Admin
  class DurationFiltersController < Admin::ApplicationRecordController

    prepend_before_action { @model = DurationFilter }

    def create
      super duration_filter_params
    end

    def update
      super duration_filter_params
    end

    def destroy
      super associations: %i[meditations]
    end

    private

      def duration_filter_params
        if policy(@duration_filter || DurationFilter).publish?
          params.fetch(:duration_filter, {}).permit(:minutes, :published)
        else
          params.fetch(:duration_filter, {}).permit(:minutes)
        end
      end

  end
end
