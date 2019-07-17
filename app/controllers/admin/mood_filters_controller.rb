module Admin
  class MoodFiltersController < Admin::ApplicationRecordController

    prepend_before_action { @model = MoodFilter }

    def create
      super mood_filter_params
    end

    def update
      super mood_filter_params
    end

    def destroy
      super associations: %i[tracks]
    end

    private

      def mood_filter_params
        if policy(@mood_filter || MoodFilter).publish?
          params.fetch(:mood_filter, {}).permit(:name, :icon, :published)
        else
          params.fetch(:mood_filter, {}).permit(:name, :icon)
        end
      end

  end
end
