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
      super associations: %i[meditations]
    end

    private

      def goal_filter_params
        if policy(@goal_filter || GoalFilter).publish?
          params.fetch(:goal_filter, {}).permit(:name, :icon, :published)
        else
          params.fetch(:goal_filter, {}).permit(:name, :icon)
        end
      end

  end
end
