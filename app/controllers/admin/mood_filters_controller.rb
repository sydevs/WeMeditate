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
      if @mood_filter.tracks.present?
        message = t('messages.result.cannot_delete_attached_record', model: MoodFilter.model_name.human.downcase, association: Meditation.model_name.human(count: -1).downcase)
        redirect_to [:admin, MoodFilter], alert: message
      else
        super
      end
    end

    private

      def mood_filter_params
        params.fetch(:mood_filter, {}).permit(:name, :icon)
      end

  end
end
