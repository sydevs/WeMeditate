class MeditationsController < ApplicationController

  def index
    @meditations = Meditation.all
    @goal_filters = GoalFilter.all
    @duration_filters = DurationFilter.all
  end

  def show
    @meditation = Meditation.find(params[:id])
  end
  
end
