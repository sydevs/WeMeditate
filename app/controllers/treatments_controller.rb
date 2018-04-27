class TreatmentsController < ApplicationController

  def index
    @treatments = Treatment.all
    @static_page = StaticPage.includes(:sections).find_by(role: :treatments)
    about_page = StaticPage.find_by(role: :about)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: 'Learn More', url: static_page_path(about_page) },
      { name: Treatment.model_name.human(count: -1), url: treatments_path },
      { name: @static_page.title }
    ]
  end

  def show
    @treatment = Treatment.friendly.find(params[:id])
    about_page = StaticPage.find_by(role: :about)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: 'Learn More', url: static_page_path(about_page) },
      { name: Treatment.model_name.human(count: -1), url: treatments_path },
      { name: @treatment.name }
    ]
  end

end
