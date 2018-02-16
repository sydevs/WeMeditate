class StaticPagesController < ApplicationController

  def show
    @static_page = StaticPage.includes(:sections).friendly.find(params[:id])
  end
  
end
