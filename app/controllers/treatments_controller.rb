class TreatmentsController < ApplicationController

  def index
    @treatments = Treatment.all
  end

  def show
    @treatment = Treatment.friendly.find(params[:id])
    @breadcrumbs = [
      { name: Treatment.model_name.human(count: -1), url: treatments_url },
      { name: @treatment.name }
    ]
  end
  
end
