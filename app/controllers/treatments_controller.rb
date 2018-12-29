class TreatmentsController < ApplicationController

  def index
    @treatments = Treatment.includes_preview.all
    @static_page = StaticPage.includes_content.find_by(role: :treatments)
    @metatags = @static_page.get_metatags
    about_page = StaticPage.includes_preview.find_by(role: :about)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: 'Learn More', url: static_page_path(about_page) },
      { name: @static_page.title }
    ]
  end

  def show
    @treatment = Treatment.includes_content.friendly.find(params[:id])
    @metatags = @treatment.get_metatags

    about_page = StaticPage.includes_preview.find_by(role: :about)
    treatments_page = StaticPage.includes_preview.find_by(role: :treatments)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: 'Learn More', url: static_page_path(about_page) },
      { name: treatments_page.title, url: treatments_path },
      { name: @treatment.name }
    ]
  end

end
