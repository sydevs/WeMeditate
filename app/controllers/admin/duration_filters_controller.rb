module Admin
  class DurationFiltersController < Admin::ApplicationResourceController
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

    def sort
      params[:order].each_with_index do |id, index|
        DurationFilter.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, DurationFilter]
    end

    private
      def duration_filter_params
        params.fetch(:duration_filter, {}).permit(:minutes)
      end

  end
end
