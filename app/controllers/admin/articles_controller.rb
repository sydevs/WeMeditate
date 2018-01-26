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
          sections_attributes: Admin::ApplicationPageController::ALLOWED_SECTION_ATTRIBUTES
        )
      end

  end
end
