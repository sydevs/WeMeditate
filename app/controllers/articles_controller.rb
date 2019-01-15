class ArticlesController < ApplicationController

  ARTICLES_PER_PAGE = 10

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :articles)
    @metadata_record = @static_page

    respond_to do |format|
      format.html {
        @categories = Category.includes(:translations).all
        @articles = Article.preload_for(:preview).limit(ARTICLES_PER_PAGE)

        @breadcrumbs = [
          { name: StaticPageHelper.preview_for(:home).name, url: root_path },
          { name: @static_page.name }
        ]
      }
      format.js {
        @articles = Article.preload_for(:preview).offset(params[:offset]).limit(ARTICLES_PER_PAGE)
        @next_offset = params[:offset].to_i + ARTICLES_PER_PAGE
      }
    end
  end

  def show
    @article = Article.preload_for(:content).friendly.find(params[:id])
    @metadata_record = @article
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: Article.model_name.human(count: -1), url: articles_path },
      { name: @article.category.name, url: articles_path(category: @article.category.id) },
      { name: @article.name }
    ]
  end

end
