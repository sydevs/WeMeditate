class TreatmentsController < ApplicationController

  def index
    @treatments = Treatment.all
    @static_page = StaticPage.includes(:sections).find_by(role: :treatments)
    @metatags = @static_page.get_metatags
    about_page = StaticPage.find_by(role: :about)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: 'Learn More', url: static_page_path(about_page) },
      { name: @static_page.title }
    ]
  end

  def show
    @treatment = Treatment.friendly.find(params[:id])
    @metatags = @treatment.get_metatags

    about_page = StaticPage.find_by(role: :about)
    treatments_page = StaticPage.find_by(role: :treatments)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: 'Learn More', url: static_page_path(about_page) },
      { name: treatments_page.title, url: treatments_path },
      { name: @treatment.name }
    ]
  end

end
