module Admin
  class MeditationsController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model Meditation
    end

    def create
      super meditation_params
    end

    def update
      super meditation_params
    end

    protected
      def set_resource
        @resource = Meditation.friendly.find(params[:id])
        @meditation = @resource
      end

    private
      def meditation_params
        result = params.fetch(:meditation, {}).permit(
          :name, :slug, :image, :audio, :duration_filter_id,
          goal_filter_ids: [],
          metatags: {}
        )

        if result[:metatags].present?
          result[:metatags] = result[:metatags][:keys].zip(result[:metatags][:values]).to_h
        end

        result
      end

  end
end
