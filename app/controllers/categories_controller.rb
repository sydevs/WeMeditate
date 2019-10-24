class CategoriesController < ApplicationController

  ARTICLES_PER_PAGE = 15

  def index
    @category = nil
    @articles = Article.publicly_visible.ordered.where.not(priority: Article.priorities[:hidden]).preload_for(:preview).offset(params[:offset]).limit(ARTICLES_PER_PAGE)
    return unless stale?(@articles)
    display
  end

  def show
    @category = Category.publicly_visible.friendly.find(params[:id])
    @articles = @category.articles.publicly_visible.ordered.where.not(priority: Article.priorities[:hidden]).preload_for(:preview).offset(params[:offset]).limit(ARTICLES_PER_PAGE)
    return unless stale?(@articles)
    display
  end

  protected

    def display
      next_offset = params[:offset].to_i + ARTICLES_PER_PAGE

      if @articles.size <= next_offset
        @loadmore_url = nil
      elsif @category.nil?
        @loadmore_url = categories_path(format: 'js', offset: next_offset)
      else
        @loadmore_url = category_path(@category, format: 'js', offset: next_offset)
      end

      respond_to do |format|
        format.html do
          @static_page = StaticPage.preload_for(:content).find_by(role: :articles)
          @categories = Category.publicly_visible.includes(articles: :translations).where(article_translations: { state: Article.states[:published] }).where('article_translations.published_at < ?', DateTime.now).where.not(articles: { id: nil })

          @breadcrumbs = [
            { name: StaticPageHelper.preview_for(:home).name, url: root_path },
            { name: @static_page.name },
          ]

          set_metadata(@static_page)
          render :show
        end

        format.js do
          render :show
        end
      end
    end

end
