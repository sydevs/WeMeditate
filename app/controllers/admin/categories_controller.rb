module Admin
  class CategoriesController < Admin::ApplicationRecordController

    prepend_before_action { @model = Category }

    def create
      super category_params
    end

    def update
      super category_params
    end

    def destroy
      super associations: %i[articles]
    end

    protected

      def set_resource
        @resource = Category.friendly.find(params[:id])
        @category = @resource
      end

    private

      def category_params
        if policy(@category || Category).publish?
          params.fetch(:category, {}).permit(:name, :slug, :show_articles_in_header, :show_articles_in_index, :published)
        else
          params.fetch(:category, {}).permit(:name, :slug)
        end
      end

  end
end
