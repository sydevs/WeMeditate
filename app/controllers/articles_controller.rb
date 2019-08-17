class ArticlesController < ApplicationController

  ARTICLES_PER_PAGE = 10

  def index
    @articles = Article.published.offset(params[:offset]).limit(ARTICLES_PER_PAGE)
    return unless stale?(@articles)

    respond_to do |format|
      format.js do
        @articles = Article.published.preload_for(:preview).offset(params[:offset]).limit(ARTICLES_PER_PAGE)
        @next_offset = params[:offset].to_i + ARTICLES_PER_PAGE
      end
    end
  end

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
