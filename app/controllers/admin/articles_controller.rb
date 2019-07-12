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
        if policy(@article || Article).update_structure?
          params.fetch(:article, {}).permit(
            :name, :slug, :category_id, :priority, :published,
            :excerpt, :banner_id, :thumbnail_id, :vimeo_id, :date, :content,
            metatags: {}
          )
        else
          params.fetch(:article, {}).permit(
            :name, :slug, :excerpt, :published,
            :banner_id, :thumbnail_id, :vimeo_id, :content
          )
        end
      end

      def update_params record_params
        return super(record_params) if @record.new_record? || !params[:article][:thumbnail]

        record_params[:thumbnail_id] = @record.media_files.create!(file: params[:article][:thumbnail]).id
        super(record_params)
      end

      def after_save
        return unless @record.new_record? && params[:article][:thumbnail]

        @record.update thumbnail_id: @record.media_files.create!(file: params[:article][:thumbnail]).id
      end

  end
end
