module Admin
  class InstrumentFiltersController < Admin::ApplicationController
    before_action :set_instrument_filter, except: [:index, :create, :sort]
    before_action :authorize!

    def index
      @instrument_filters = InstrumentFilter.all
    end

    def create
      @instrument_filter = InstrumentFilter.new instrument_filter_params
      @instrument_filter.save

      if @instrument_filter.errors.empty?
        redirect_to [:admin, InstrumentFilter]
      else
        redirect_to [:admin, InstrumentFilter], alert: @instrument_filter.errors.messages
      end
    end

    def update
      if @instrument_filter.update instrument_params
        head :ok
      else
        format.json { render json: @instrument_filter.errors, status: :unprocessable_entity }
      end
    end

    def sort
      params[:order].each_with_index do |id, index|
        InstrumentFilter.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, InstrumentFilter]
    end

    def destroy
      if @instrument_filter.tracks.count > 0
        redirect_to [:admin, InstrumentFilter], alert: 'You cannot delete a filter which has tracks attached to it. Reassign the tracks and try again.'
      else
        @instrument_filter.destroy
        redirect_to [:admin, InstrumentFilter]
      end
    end

    protected
      def instrument_filter_params
        params.fetch(:instrument_filter, {}).permit(:name, :icon)
      end

      def set_instrument_filter
        @instrument_filter = InstrumentFilter.find(params[:id])
      end

      def authorize!
        authorize @instrument_filter || InstrumentFilter
      end

      def self.policy_class
        Admin::FilterPolicy
      end

  end
end
