module Admin
  class ArticlesController < Admin::ApplicationRecordController

    prepend_before_action { @model = Article }

    def create
      super article_params
    end

    def update
      super article_params
    end

    protected

      def article_params
        allow = policy(@record || Article)
        if (allow.create? && action_name == 'create') || allow.update_structure?
          params.fetch(:article, {}).permit(
            :name, :slug, :category_id, :priority, :state, :published_at, :owner_id, :article_type,
            :excerpt, :banner_id, :thumbnail_id, :vimeo_id, :content,
            :author_id, :latitude, :longitude, :date,
            :table_of_contents, :table_of_contents_position,
            metatags: {}
          )
        else
          params.fetch(:article, {}).permit(
            :name, :slug, :excerpt, :state, :published_at,
            :banner_id, :thumbnail_id, :vimeo_id, :content
          )
        end
      end

      def update_params record_params
        if defined?(@record) && params[:article][:thumbnail].present?
          record_params[:thumbnail_id] = @record.media_files.create!(file: params[:article][:thumbnail]).id
        end

        super record_params
      end

      def after_create
        return unless params[:article][:thumbnail]

        media_file = @record.media_files.create!(file: params[:article][:thumbnail])
        @record.thumbnail_id = media_file.id
        @record.save!(validate: @record.published?)
      end

  end
end
