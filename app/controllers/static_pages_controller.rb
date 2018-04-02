class StaticPagesController < ApplicationController

  def show
    @static_page = StaticPage.includes(:sections).friendly.find(params[:id])

    if @static_page.role == 'about'
      @breadcrumbs = [
        { name: 'Home', url: root_path },
        { name: @static_page.title }
      ]
    else
      @about_page = StaticPage.find_by(role: :about)
      @breadcrumbs = [
        { name: 'Home', url: root_path },
        { name: @about_page.title, url: static_page_path(about_page) },
        { name: @static_page.title }
      ]
    end
  end

end
