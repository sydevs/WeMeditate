module Admin
    class ArticlesController < Admin::ApplicationController
      before_action :set_article, except: [:index, :create, :new]
      before_action :authorize!, except: [:create]

      def index
        @articles = Article.all
      end

      def new
        @article = Article.new
      end

      def create
        @article = Article.new article_params
        authorize @article

        if @article.save
          redirect_to [:admin, Article]
        else
          render :new
        end
      end
  
      def edit
      end

      def update
        atts = article_params

        print params
        print "\r\n"
        print article_params
        print "\r\n"

        if params[:article][:reset_slug]
          atts[:slug] = nil
        end

        if @article.update atts
          redirect_to edit_admin_article_path(@article)
          #redirect_to [:admin, Article]
        else
          render :edit
        end
      end

      def destroy
        @article.destroy
      end

      private
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

        def set_article
          @article = Article.friendly.find(params[:id])
        end

        def authorize!
          authorize @article || Article
        end
  
    end
  end
  