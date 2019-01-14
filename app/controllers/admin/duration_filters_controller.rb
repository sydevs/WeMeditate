module Admin
  class DurationFiltersController < Admin::ApplicationRecordController
    prepend_before_action do
      set_model DurationFilter
    end

    def create
      super duration_filter_params
    end

    def update
      super duration_filter_params
    end

    def destroy
      if @duration_filter.meditations.count > 0
        redirect_to [:admin, DurationFilter], alert: t('messages.result.cannot_delete_attached_record', model: DurationFilter.model_name.human.downcase, association: Meditation.model_name.human(count: -1).downcase)
      else
        super
      end
    end

    private
      def duration_filter_params
        params.fetch(:duration_filter, {}).permit(:minutes)
      end

  end
end
