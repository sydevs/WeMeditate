class StaticPagesController < ApplicationController

  def show
    @static_page = StaticPage.includes_content.friendly.find(params[:id])
    @metatags = @static_page.get_metatags

    case @static_page.role
    when 'about'
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).title, url: root_path },
        { name: @static_page.title }
      ]
    else
      about_page = StaticPage.includes_preview.find_by(role: :about)
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).title, url: root_path },
        { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
        { name: @static_page.title }
      ]
    end
  end

end
