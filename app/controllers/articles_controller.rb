class ArticlesController < ApplicationController

  ARTICLES_PER_PAGE = 10

  def index
    respond_to do |format|
      format.html do
        @static_page = StaticPage.preload_for(:content).find_by(role: :articles)
        @metadata_record = @static_page
        @categories = Category.includes(:translations).all
        #@articles = Article.published.preload_for(:preview).limit(ARTICLES_PER_PAGE)
        @article = Article.joins(:translations).where(slug: 'article-13', published: 'true')

        @breadcrumbs = [
          { name: StaticPageHelper.preview_for(:home).name, url: root_path },
          { name: @static_page.name },
        ]
      end

      format.js do
        @articles = Article.published.preload_for(:preview).offset(params[:offset]).limit(ARTICLES_PER_PAGE)
        @next_offset = params[:offset].to_i + ARTICLES_PER_PAGE
      end
    end
  end

  def show
    if authorized_preview?(Article)
      @record = Article.preload_for(:content).friendly.find(params[:id])
      @record.reify_draft!
    else
      @record = Article.published.preload_for(:content).friendly.find(params[:id])
    end

    # TODO: Deprecated
    @article = @record
    @metadata_record = @article

    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: StaticPageHelper.preview_for(:articles).name, url: categories_path },
      { name: @article.category.name, url: category_path(@article.category) },
      { name: @article.name },
    ]
  end

end
