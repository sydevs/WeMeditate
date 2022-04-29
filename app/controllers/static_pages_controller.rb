class StaticPagesController < ApplicationController

  def show
    @static_page = StaticPage.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return if redirect_legacy_url(@static_page)
    return redirect_to helpers.static_page_path_for(@static_page) unless helpers.static_page_path_for(@static_page) == request.path
    return unless stale?(@static_page)

    case @static_page.role
    when 'about'
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).name, url: root_path },
        { name: @static_page.name },
      ]
    when 'classes'
      # Do nothing, the classes page has no breadcrumbs
    else
      about_page = StaticPageHelper.preview_for(:home)
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).name, url: root_path },
        { name: I18n.t('header.advanced'), url: static_page_path(about_page) },
        { name: @static_page.name },
      ]
    end

    set_metadata(@static_page)
  end

end
