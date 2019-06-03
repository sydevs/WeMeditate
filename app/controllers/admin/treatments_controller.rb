module Admin
  class TreatmentsController < Admin::ApplicationRecordController

    prepend_before_action { @model = Treatment }

    def create
      super treatment_params
    end

    def update
      super treatment_params
    end

    private

      def treatment_params
        params.fetch(:treatment, {}).permit(
          :name, :slug, :excerpt, :content, :thumbnail, :video,
          metatags: {}
        )
      end

  end
end
