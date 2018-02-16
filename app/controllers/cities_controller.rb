class CitiesController < ApplicationController

    def show
      @city = City.includes(:sections).friendly.find(params[:id])
    end
  
  end
  