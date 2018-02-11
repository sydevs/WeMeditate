class TreatmentsController < ApplicationController

  def index
    @treatments = Treatment.all
  end

  def show
    @treatment = Treatment.friendly.find(params[:id])
  end
  
end
