module Admin
  class MoodFiltersController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model MoodFilter
    end

    def create
      super mood_filter_params
    end

    def update
      super mood_filter_params
    end

    def destroy
      if @mood_filter.tracks.count > 0
        redirect_to [:admin, MoodFilter], alert: 'You cannot delete a filter which has tracks attached to it. Reassign the tracks and try again.'
      else
        super
      end
    end

    def sort
      params[:order].each_with_index do |id, index|
        MoodFilter.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, MoodFilter]
    end

    private
      def mood_filter_params
        params.fetch(:mood_filter, {}).permit(:name)
      end

      def self.policy_class
        Admin::FilterPolicy
      end

  end
end
