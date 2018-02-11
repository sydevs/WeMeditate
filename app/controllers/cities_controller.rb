class CitiesController < ApplicationController

    def show
      @city = City.friendly.find(params[:id])
    end
  
  end
  