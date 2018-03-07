class CitiesController < ApplicationController

  def index
    @cities = City.with_translations(I18n.locale)
  end

  def show
    @city = City.includes(:sections).friendly.find(params[:id])
  end

end
