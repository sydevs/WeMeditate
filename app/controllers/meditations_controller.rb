class MeditationsController < ApplicationController

  def index
    @meditations = Meditation.all
    @goal_filters = GoalFilter.all
    @duration_filters = DurationFilter.all
  end

  def show
    @meditation = Meditation.friendly.find(params[:id])
    render layout: 'basic'
  end
  
end
