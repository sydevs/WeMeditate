module Admin
  class TreatmentsController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model Treatment
    end

    def create
      super treatment_params
    end

    def update
      super treatment_params
    end

    def sort
      params[:order].each_with_index do |id, index|
        Treatment.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, Treatment]
    end

    protected
      def set_resource
        @resource = Treatment.friendly.find(params[:id])
        @treatment = @resource
      end

    private
      def treatment_params
        result = params.fetch(:treatment, {}).permit(
          :name, :slug, :excerpt, :content, :thumbnail, :video,
          metatags: {}
        )

        if result[:metatags].present?
          result[:metatags] = result[:metatags][:keys].zip(result[:metatags][:values]).to_h
        end

        result
      end

  end
end
