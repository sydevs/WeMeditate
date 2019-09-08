class ArticlesController < ApplicationController

  def show
    @article = Article.published.preload_for(:content).friendly.find(params[:id])
    return unless stale?(@article)

    set_metadata(@article)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: StaticPageHelper.preview_for(:articles).name, url: categories_path },
      { name: @article.category.name, url: category_path(@article.category) },
      { name: @article.name },
    ]
  end

end
