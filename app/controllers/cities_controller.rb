class CitiesController < ApplicationController

  def index
    @cities = City.with_translations(I18n.locale).select(:name, :country, :slug)
  end

  def country
    #@cities = City.with_translations(I18n.locale).where(country: City.countries[params[:country_code]])
    @static_page = StaticPage.find_by(role: :country)
    @breadcrumbs = [
      { name: City.model_name.human(count: -1), url: cities_path },
      { name: I18nData.countries(I18n.locale)[params[:country_code].upcase] }
    ]
  end

  def show
    @city = City.includes(:sections).friendly.find(params[:id])
    @breadcrumbs = [
      { name: City.model_name.human(count: -1), url: cities_path },
      { name: I18nData.countries(I18n.locale)[@city.country], url: countries_path(country_code: @city.country) },
      { name: @city.name }
    ]
  end

end
