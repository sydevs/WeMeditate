module Admin
  class TreatmentsController < Admin::ApplicationRecordController
    prepend_before_action do
      set_model Treatment
    end

    def create
      super treatment_params
    end

    def update
      super treatment_params
    end

    private
      def treatment_params
        result = params.fetch(:treatment, {}).permit(
          :name, :slug, :excerpt, :content, :thumbnail, :video,
          metatags: {}
        )

        result
      end

  end
end
