module Admin
  class GoalFiltersController < Admin::ApplicationRecordController

    prepend_before_action { @model = GoalFilter }

    def create
      super goal_filter_params
    end

    def update
      super goal_filter_params
    end

    def destroy
      if @goal_filter.meditations.present?
        message = t('messages.result.cannot_delete_attached_record', model: GoalFilter.model_name.human.downcase, association: Track.model_name.human(count: -1).downcase)
        redirect_to [:admin, GoalFilter], alert: message
      else
        super
      end
    end

    private

      def goal_filter_params
        params.fetch(:goal_filter, {}).permit(:name, :icon)
      end

  end
end
