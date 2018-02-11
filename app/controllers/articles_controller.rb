class ArticlesController < ApplicationController

  def show
    @article = Article.friendly.find(params[:id])
  end

end
