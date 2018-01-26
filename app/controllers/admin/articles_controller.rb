module Admin
  class ArticlesController < Admin::ApplicationPageController
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
        params.fetch(:article, {}).permit(
          :title, :category_id, :priority,
          sections_attributes: [
            :id, :order, :_destroy, # Meta fields
            :header, :content_type, :visibility_type, :visibility_countries,
            :text, :youtube_id, :image # These are the options for different content_types
          ]
        )
      end

  end
end
