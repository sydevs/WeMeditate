class TreatmentsController < ApplicationController

  def index
    @treatments = Treatment.preload_for(:preview).all
    @record = StaticPage.preload_for(:content).find_by(role: :treatments)
    @tracks = Track.order('RANDOM()').limit(10)

    # TODO: Deprecated
    @static_page = @record
    @metadata_record = @static_page

    about_page = StaticPage.preload_for(:preview).find_by(role: :about)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
      { name: @static_page.name },
    ]
  end

  def show
    @treatment = Treatment.preload_for(:content).friendly.find(params[:id])
    @metadata_record = @treatment

    about_page = StaticPage.preload_for(:preview).find_by(role: :about)
    treatments_page = StaticPage.preload_for(:preview).find_by(role: :treatments)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
      { name: treatments_page.name, url: treatments_path },
      { name: @treatment.name },
    ]
  end

end
