module Admin
  class MeditationsController < Admin::ApplicationRecordController

    prepend_before_action { @model = Meditation }

    def new
      @record = @model.new slug: params[:slug]
      render 'admin/application/new'
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
        if policy(@meditation || Meditation).publish?
          result = params.fetch(:meditation, {}).permit(
            :name, :slug, :state, :published_at,
            :thumbnail_id, :excerpt, :description,
            :horizontal_vimeo_id, :vertical_vimeo_id, :duration_filter_id,
            vimeo_metadata: {},
            goal_filter_ids: [],
            metatags: {}
          )
        else
          result = params.fetch(:meditation, {}).permit(
            :name, :slug, :state, :published_at,
            :thumbnail_id, :excerpt, :description,
            :horizontal_vimeo_id, :vertical_vimeo_id, :duration_filter_id,
            vimeo_metadata: {},
            goal_filter_ids: [],
            metatags: {}
          )
        end

        result
      end

      def update_params record_params
        if defined?(@record) && params[:meditation][:thumbnail].present?
          record_params[:thumbnail_id] = @record.media_files.create!(file: params[:meditation][:thumbnail]).id
        end

        if defined?(@record) && params[:meditation][:vimeo_metadata].present?
          record_params[:vimeo_metadata][:horizontal] = (JSON.parse(record_params[:vimeo_metadata][:horizontal]) rescue {})
          record_params[:vimeo_metadata][:vertical] = (JSON.parse(record_params[:vimeo_metadata][:vertical]) rescue {})
        end

        super record_params
      end

      def after_create
        if params[:meditation][:thumbnail]
          media_file = @record.media_files.create!(file: params[:meditation][:thumbnail])
          @record.thumbnail_id = media_file.id
          @record.save!(validate: @record.published?)
        end
      end

  end
end
