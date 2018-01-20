module Admin
    class CategoriesController < Admin::ApplicationController
      before_action :set_category, except: [:index, :create]

      def index
        @categories = Category.all
      end

      def create
        @category = Category.new category_params
        @category.save
        redirect_to [:admin, Category]
      end

      def update
        @category.update category_params
        #head :ok
        redirect_to [:admin, Category]
      end

      def destroy
        @category.destroy #if @category.documents.count == 0
        redirect_to [:admin, Category]
      end

      private
        def category_params
          params.fetch(:category, {}).permit(:name)
        end

        def set_category
          @category = Category.friendly.find(params[:id])
        end
  
    end
  end
  