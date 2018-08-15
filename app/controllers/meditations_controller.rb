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

    # Increment the view counter for this page. This should be changed to be less naive, and actually check when people view the video.
    @meditation.update! views: @meditation.views + 1

    meditations_page = StaticPage.find_by(role: :meditations)
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: meditations_page.title, url: meditations_path },
      { name: @meditation.name }
    ]
  end

  def random
    redirect_to meditation_url(Meditation.get(:random)), status: :see_other
  end

  def find
    #redirect_to meditation_url(Meditation.get(:random)), status: :see_other
    redirect_to meditations_url
  end

  def record_view
    meditation = Meditation.friendly.find(params[:id])
    meditation.update! views: meditation.views + 1
  end

end
