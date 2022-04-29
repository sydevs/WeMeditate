class ArticlesController < ApplicationController

  def show
    @article = Article.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return if redirect_legacy_url(@article)
    return unless stale?(@article)

    @breadcrumbs = [
      { name: StaticPage.preview(:home).name, url: root_path },
      { name: StaticPage.preview(:articles).name, url: categories_path },
      { name: @article.category.name, url: category_path(@article.category) },
      { name: @article.name },
    ]

    set_metadata(@article)
  end

end
