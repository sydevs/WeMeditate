module Admin
  class InstrumentFiltersController < Admin::ApplicationRecordController

    prepend_before_action { @model = InstrumentFilter }

    def create
      super instrument_filter_params
    end

    def update
      super instrument_filter_params
    end

    def destroy
      super associations: %i[tracks]
    end

    private

      def instrument_filter_params
        if policy(@instrument_filter || InstrumentFilter).publish?
          params.fetch(:instrument_filter, {}).permit(:name, :icon, :published)
        else
          params.fetch(:instrument_filter, {}).permit(:name, :icon)
        end
      end

  end
end
