class ArticlesController < ApplicationController

  ARTICLES_PER_PAGE = 10

  def index
    respond_to do |format|
      format.html {
        @categories = Category.all
        @articles = Article.limit(ARTICLES_PER_PAGE)
      }
      format.js {
        @articles = Article.offset(params[:offset]).limit(ARTICLES_PER_PAGE)
        @next_offset = params[:offset].to_i + ARTICLES_PER_PAGE
      }
    end
  end

  def show
    @article = Article.includes(:sections).friendly.find(params[:id])
    @breadcrumbs = [
      { name: Article.model_name.human(count: -1), url: articles_path },
      { name: @article.category.name, url: articles_path(category: @article.category.id) },
      { name: @article.title }
    ]
  end

end
