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
      if @duration_filter.meditations.present?
        message = t('messages.result.cannot_delete_attached_record', model: DurationFilter.model_name.human.downcase, association: Meditation.model_name.human(count: -1).downcase)
        redirect_to [:admin, DurationFilter], alert: message
      else
        super
      end
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
