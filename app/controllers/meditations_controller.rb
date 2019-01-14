class MeditationsController < ApplicationController

  def index
    @meditations = Meditation.preload_for(:preview).all
    @goal_filters = GoalFilter.includes(:translations).all
    @duration_filters = DurationFilter.all
    @static_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    @metatags = @static_page.get_metatags

    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name }
    ]
  end

  def show
    @meditation = Meditation.friendly.find(params[:id])
    @metatags = @meditation.get_metatags

    # Increment the view counter for this page. This should be changed to be less naive, and actually check when people view the video.
    @meditation.update! views: @meditation.views + 1

    meditations_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: meditations_page.name, url: meditations_path },
      { name: @meditation.name }
    ]
  end

  def random
    redirect_to meditation_url(Meditation.get(:random)), status: :see_other
  end

  def find
    where = {}
    where[:duration_filter_id] = params[:duration_filter] if params[:duration_filter].present?
    where[:goal_filters] = { id: params[:goal_filter] } if params[:goal_filter].present?
    meditation = Meditation.joins(:goal_filters).where(where).order('RANDOM()').first

    if meditation.present?
      redirect_to meditation_url(meditation), status: :see_other
    else
      raise ActionController::RoutingError.new('Filter Not Found')
    end
  end

  def record_view
    meditation = Meditation.friendly.find(params[:id])
    meditation.update! views: meditation.views + 1
  end

end
