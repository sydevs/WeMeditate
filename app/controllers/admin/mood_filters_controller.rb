module Admin
  class MoodFiltersController < Admin::ApplicationController
    before_action :set_mood_filter, except: [:index, :create, :sort]
    before_action :authorize!

    def index
      @mood_filters = MoodFilter.all
    end

    def create
      @mood_filter = MoodFilter.new mood_filter_params
      @mood_filter.save

      if @mood_filter.errors.empty?
        redirect_to [:admin, MoodFilter]
      else
        redirect_to [:admin, MoodFilter], alert: @mood_filter.errors.messages
      end
    end

    def update
      if @mood_filter.update mood_filter_params
        head :ok
      else
        format.json { render json: @mood_filter.errors, status: :unprocessable_entity }
      end
    end

    def sort
      params[:order].each_with_index do |id, index|
        MoodFilter.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, MoodFilter]
    end

    def destroy
      if @mood_filter.tracks.count > 0
        redirect_to [:admin, MoodFilter], alert: 'You cannot delete a filter which has tracks attached to it. Reassign the tracks and try again.'
      else
        @mood_filter.destroy
        redirect_to [:admin, MoodFilter]
      end
    end

    protected
      def mood_filter_params
        params.fetch(:mood_filter, {}).permit(:name)
      end

      def set_mood_filter
        @mood_filter = MoodFilter.find(params[:id])
      end

      def authorize!
        authorize @mood_filter || MoodFilter
      end

      def self.policy_class
        Admin::FilterPolicy
      end

  end
end
