module Admin
  class CategoriesController < Admin::ApplicationResourceController
    prepend_before_action do
      set_model Category
    end

    def create
      super category_params
    end

    def update
      super category_params
    end

    def sort
      params[:order].each_with_index do |id, index|
        Category.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, Category]
    end

    def destroy
      if @category.articles.count > 0
        redirect_to [:admin, Category], alert: 'You cannot delete a category which has articles attached to it. Reassign the articles and try again.'
      else
        super
      end
    end

    protected
      def set_resource
        @resource = Category.friendly.find(params[:id])
        @category = @resource
      end

    private
      def category_params
        params.fetch(:category, {}).permit(:name, :slug)
      end

  end
end
