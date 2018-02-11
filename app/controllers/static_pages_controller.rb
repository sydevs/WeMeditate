class StaticPagesController < ApplicationController

  def show
    @static_page = StaticPage.friendly.find(params[:id])
  end
  
end
