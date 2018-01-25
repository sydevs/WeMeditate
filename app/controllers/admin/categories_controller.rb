module Admin
  class CategoriesController < Admin::ApplicationController
    before_action :set_category, except: [:index, :create, :sort]
    before_action :authorize!, except: [:create]

    def index
      @categories = Category.all
    end

    def create
      @category = Category.new category_params
      authorize @category
      @category.save
      redirect_to [:admin, Category]
    end

    def update
      atts = category_params

      if params[:category][:reset_slug]
        atts.merge slug: nil
      end

      if @category.update atts
        redirect_to [:admin, Category]
      else
        respond_to do |category|
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
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
        @category.destroy
        redirect_to [:admin, Category]
      end
    end

    private
      def category_params
        params.fetch(:category, {}).permit(:name)
      end

      def set_category
        @category = Category.friendly.find(params[:id])
      end

      def authorize!
        authorize @category || Category
      end

  end
end
