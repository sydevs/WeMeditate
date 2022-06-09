class StaticPagesController < ApplicationController

  def show
    slug = CGI.unescape(request.path.split('/').last)
    @static_page = StaticPage.publicly_visible.preload_for(:content).find_by_slug(slug)
    puts "STATIC PAGE FOR #{I18n.locale}/#{Globalize.locale}, #{slug.inspect}, #{@static_page}"
    return if redirect_legacy_url(@static_page)
    return redirect_to helpers.static_page_path(@static_page) unless helpers.static_page_path(@static_page) == request.path
    return unless stale?(@static_page)

    case @static_page.role
    when 'about'
      @breadcrumbs = [
        { name: StaticPage.preview(:home).name, url: root_path },
        { name: @static_page.name },
      ]
    when 'classes'
      # Do nothing, the classes page has no breadcrumbs
    else
      about_page = StaticPage.preview(:home)
      @breadcrumbs = [
        { name: StaticPage.preview(:home).name, url: root_path },
        { name: I18n.t('header.advanced'), url: helpers.static_page_path(about_page) },
        { name: @static_page.name },
      ]
    end

    set_metadata(@static_page)
  end

end
