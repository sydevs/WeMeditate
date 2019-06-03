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
            :name, :slug, :category_id, :priority, :excerpt, :banner_id, :thumbnail_id, :video_id, :date, :content,
            metatags: {}
          )
        else
          params.fetch(:article, {}).permit(
            :name, :slug, :excerpt, :banner_id, :thumbnail_id, :video_id, :content
          )
        end
      end

  end
end
