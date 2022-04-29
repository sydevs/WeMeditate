class PromoPagesController < ApplicationController

  def show
    @promo_page = PromoPage.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return if redirect_legacy_url(@promo_page)
    return unless stale?(@promo_page)

    set_metadata(@promo_page)
  rescue ActiveRecord::RecordNotFound
    @article = Article.publicly_visible.type_event.friendly.find(params[:id])
    redirect_to @article, status: :moved_permanently if @article.present?
  end

end
