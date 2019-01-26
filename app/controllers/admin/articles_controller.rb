module Admin
  class ArticlesController < Admin::ApplicationRecordController
    prepend_before_action do
      set_model Article
    end

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
            :name, :slug, :category_id, :priority, :excerpt, :banner_id, :thumbnail_id, :video_id, :date,
            metatages: {}
          )
        else
          params.fetch(:article, {}).permit(
            :name, :slug, :excerpt, :banner_id, :thumbnail_id, :video_id,
          )
        end
      end

  end
end
