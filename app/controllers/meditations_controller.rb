class MeditationsController < ApplicationController

  def index
    @meditations = Meditation.all
    @goal_filters = GoalFilter.all
    @duration_filters = DurationFilter.all
    @static_page = StaticPage.includes(:sections).find_by(role: :meditations)
    @metatags = @static_page.get_metatags

    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: @static_page.title }
    ]
  end

  def show
    @meditation = Meditation.friendly.find(params[:id])
    @metatags = @meditation.get_metatags

    meditations_page = StaticPage.find_by(role: :meditations)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: meditations_page.title, url: meditations_path },
      { name: @meditation.name }
    ]
  end

  def find
    redirect_to meditation_url(Meditation.order('RANDOM()').first), status: :see_other
  end

end
