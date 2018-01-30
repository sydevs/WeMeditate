module Admin
  class TreatmentsController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model Treatment
    end

    def create
      super treatment_params
    end

    def update
      atts = treatment_params

      if params[:reset_slug]
        atts.merge slug: nil
      end

      super atts
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
        params.fetch(:treatment, {}).permit(:name, :excerpt, :content)
      end

  end
end
