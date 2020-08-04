class ArticlesController < ApplicationController

  before_action :redirect_article

  def show
    @article = Article.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return unless stale?(@article)

    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: StaticPageHelper.preview_for(:articles).name, url: categories_path },
      { name: @article.category.name, url: category_path(@article.category) },
      { name: @article.name },
    ]

    set_metadata(@article)
  end

  def redirect_article
    @article = Article.friendly.find(params[:id])

    return redirect_to @article, status: :moved_permanently unless request.path == article_path(@article)
  end

end
