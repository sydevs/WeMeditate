class ArticlesController < ApplicationController

  ARTICLES_PER_PAGE = 10

  def index
    @static_page = StaticPage.includes_content.find_by(role: :articles)
    @metatags = @static_page.get_metatags

    respond_to do |format|
      format.html {
        @categories = Category.includes(:translations).all
        @articles = Article.includes_preview.limit(ARTICLES_PER_PAGE)

        @breadcrumbs = [
          { name: 'Home', url: root_path },
          { name: @static_page.title }
        ]
      }
      format.js {
        @articles = Article.includes_preview.offset(params[:offset]).limit(ARTICLES_PER_PAGE)
        @next_offset = params[:offset].to_i + ARTICLES_PER_PAGE
      }
    end
  end

  def show
    @article = Article.includes_content.friendly.find(params[:id])
    @metatags = @article.get_metatags
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: Article.model_name.human(count: -1), url: articles_path },
      { name: @article.category.name, url: articles_path(category: @article.category.id) },
      { name: @article.title }
    ]
  end

end
