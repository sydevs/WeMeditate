class MeditationsController < ApplicationController

  def index
    @meditations = Meditation.all
    @goal_filters = GoalFilter.all
    @duration_filters = DurationFilter.all
    @static_page = StaticPage.includes(:sections).find_by(role: :meditations)
  end

  def show
    @meditation = Meditation.friendly.find(params[:id])
    render layout: 'basic'
  end

end
