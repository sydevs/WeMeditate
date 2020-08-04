class TreatmentsController < ApplicationController

  before_action :redirect_treatment, except: [:index]

  def index
    @treatments = Treatment.publicly_visible.preload_for(:preview).all
    @static_page = StaticPage.preload_for(:content).find_by(role: :treatments)
    @tracks = Track.order('RANDOM()').limit(10)

    about_page = StaticPage.preload_for(:preview).find_by(role: :about)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
      { name: @static_page.name },
    ]

    set_metadata(@static_page)
  end

  def show
    @treatment = Treatment.publicly_visible.preload_for(:content).friendly.find(params[:id])

    about_page = StaticPage.preload_for(:preview).find_by(role: :about)
    treatments_page = StaticPage.preload_for(:preview).find_by(role: :treatments)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: I18n.t('header.learn_more'), url: static_page_path(about_page) },
      { name: treatments_page.name, url: treatments_path },
      { name: @treatment.name },
    ]

    set_metadata(@treatment)
  end

  def redirect_treatment
    @treatment = Treatment.friendly.find(params[:id])

    if request.path != treatment_path(@treatment)
      return redirect_to @treatment, :status => :moved_permanently
    end
  end

end
