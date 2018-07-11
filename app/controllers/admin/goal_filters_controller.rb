module Admin
  class GoalFiltersController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model GoalFilter
    end

    def create
      super goal_filter_params
    end

    def update
      super goal_filter_params
    end

    def destroy
      if @goal_filter.meditations.count > 0
        redirect_to [:admin, GoalFilter], alert: t('messages.result.cannot_delete_attached_record', model: GoalFilter.model_name.human.downcase, association: Track.model_name.human(count: -1).downcase)
      else
        super
      end
    end

    def sort
      params[:order].each_with_index do |id, index|
        GoalFilter.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, GoalFilter]
    end

    private
      def goal_filter_params
        params.fetch(:goal_filter, {}).permit(:name)
      end

  end
end
