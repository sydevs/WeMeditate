module Admin
  class InstrumentFiltersController < Admin::ApplicationResourceController
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
        redirect_to [:admin, InstrumentFilter], alert: 'You cannot delete a filter which has tracks attached to it. Reassign the tracks and try again.'
      else
        super
      end
    end

    def sort
      params[:order].each_with_index do |id, index|
        InstrumentFilter.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, InstrumentFilter]
    end

    private
      def instrument_filter_params
        params.fetch(:instrument_filter, {}).permit(:name, :icon)
      end

      def self.policy_class
        Admin::FilterPolicy
      end

  end
end
