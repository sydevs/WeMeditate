class StaticPagesController < ApplicationController

  def show
    @record = StaticPage.friendly.find(params[:id])
    return unless stale?(@record)

    @record = StaticPage.preload_for(:content).friendly.find(params[:id])

    # TODO: Deprecated
    @static_page = @record
    @metadata_record = @static_page

    case @static_page.role
    when 'about'
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).name, url: root_path },
        { name: @static_page.name },
      ]
    when 'classes'
      # Do nothing
    else
      about_page = StaticPageHelper.preview_for(:home)
      @breadcrumbs = [
        { name: StaticPageHelper.preview_for(:home).name, url: root_path },
        { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
        { name: @static_page.name },
      ]
    end
  end

end
