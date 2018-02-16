class ArticlesController < ApplicationController

  def index
    @categories = Category.all
    @articles = Article.all
    @selected_category = Category.friendly.find(params[:category_id]) rescue nil
  end

  def show
    @article = Article.includes(:sections).friendly.find(params[:id])
    @breadcrumbs = [
      { name: Article.model_name.human(count: -1), url: articles_url },
      { name: @article.category.name, url: '#' },
      { name: @article.title }
    ]
  end

end
