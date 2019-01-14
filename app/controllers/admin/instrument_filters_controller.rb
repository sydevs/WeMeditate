module Admin
  class InstrumentFiltersController < Admin::ApplicationRecordController
    prepend_before_action do
      set_model InstrumentFilter
    end

    def create
      super instrument_filter_params
    end

    def update
      super instrument_filter_params
    end

    def destroy
      if @instrument_filter.tracks.count > 0
        redirect_to [:admin, InstrumentFilter], alert: t('messages.result.cannot_delete_attached_record', model: InstrumentFilter.model_name.human.downcase, association: Track.model_name.human(count: -1).downcase)
      else
        super
      end
    end

    private
      def instrument_filter_params
        params.fetch(:instrument_filter, {}).permit(:name, :icon)
      end

  end
end
