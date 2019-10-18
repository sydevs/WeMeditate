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
        if policy(@treatment || Treatment).publish?
          params.fetch(:treatment, {}).permit(
            :name, :slug, :state, :excerpt, :content,
            :thumbnail_id, :horizontal_vimeo_id, :vertical_vimeo_id,
            metatags: {}
          )
        else
          params.fetch(:treatment, {}).permit(
            :name, :slug, :state, :excerpt, :content,
            :thumbnail_id, :horizontal_vimeo_id, :vertical_vimeo_id,
            metatags: {}
          )
        end
      end

      def update_params record_params
        if defined?(@record) && params[:treatment][:thumbnail].present?
          record_params[:thumbnail_id] = @record.media_files.create!(file: params[:treatment][:thumbnail]).id
        end

        super record_params
      end

      def after_create
        if params[:treatment][:thumbnail]
          media_file = @record.media_files.create!(file: params[:treatment][:thumbnail])
          @record.update!(thumbnail_id: media_file.id)
        end

        @record.valid?
      end

  end
end
