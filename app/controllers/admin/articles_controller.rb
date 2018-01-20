module Admin
    class ArticlesController < Admin::ApplicationController
      before_action :set_article, except: [:index, :create, :new]

      def index
        @articles = Article.all
      end

      def new
        @article = Article.new
      end

      def create
        @article = Article.new article_params

        if @article.save
          redirect_to [:admin, Article]
        else
          render :new
        end
      end
  
      def edit
      end

      def update
        @article.update article_params

        if params[:reset_slug]
          @article.update slug: nil
        end

        if @article.errors.present?
          render :edit
        else
          redirect_to [:admin, Article]
        end
      end

      def destroy
        @article.destroy
      end

      private
        def article_params
          params.fetch(:article, {}).permit(:title, :category_id)
        end

        def set_article
          @article = Article.friendly.find(params[:id])
        end
  
    end
  end
  