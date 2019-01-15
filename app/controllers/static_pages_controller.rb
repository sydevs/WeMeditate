class StaticPagesController < ApplicationController

  def show
    @static_page = StaticPage.preload_for(:content).friendly.find(params[:id])
    @metadata_record = @static_page

    case @static_page.role
    when 'about'
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).name, url: root_path },
        { name: @static_page.name }
      ]
    else
      about_page = StaticPage.preload_for(:preview).find_by(role: :about)
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).name, url: root_path },
        { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
        { name: @static_page.name }
      ]
    end
  end

end
