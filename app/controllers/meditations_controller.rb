class MeditationsController < ApplicationController

  MEDITATIONS_PER_PAGE = 10

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    # expires_in 12.hours, public: true

    set_metadata(@static_page)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name },
    ]

    if true || cookies[:prescreen] == 'dismissed'
      @meditations = Meditation.preload_for(:preview).all
      @goal_filters = GoalFilter.published.has_content
      @duration_filters = DurationFilter.published.has_content
    else
      render :prescreen
    end
  end

  def self_realization
    @meditation = Meditation.published.get(:self_realization)
    raise ActionController::RoutingError.new('Self Realization Page Not Found') if @meditation.nil?
    set_metadata(@meditation)
    render :show
  end

  def archive
    next_offset = params[:offset].to_i + MEDITATIONS_PER_PAGE
    @meditations = Meditation.published.preload_for(:preview).offset(params[:offset]).limit(MEDITATIONS_PER_PAGE)
    return unless stale?(@meditations)

    set_metadata({ 'title' => helpers.human_model_name(Meditation, :plural) })

    if Meditation.published.count <= next_offset
      @loadmore_url = nil
    else
      @loadmore_url = archive_meditations_path(format: 'js', offset: next_offset)
    end

    respond_to do |format|
      format.html do
        @breadcrumbs = [
          { name: StaticPageHelper.preview_for(:home).name, url: root_path },
          { name: StaticPageHelper.preview_for(:meditations).name, url: meditations_path },
          { name: helpers.human_model_name(Meditation, :plural), url: archive_meditations_path },
          { name: translate('meditations.archive.title') },
        ]
        render :archive
      end

      format.js do
        render :archive
      end
    end
  end

  def show
    @meditation = Meditation.published.friendly.find(params[:id])

    set_metadata(@meditation)
    meditations_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: meditations_page.name, url: meditations_path },
      { name: @meditation.name },
    ]

    if cookies[:prescreen] == 'dismissed'
      # Increment the view counter for this page.
      @meditation.update! views: @meditation.views + 1, popularity: @meditation.popularity + 1 unless @meditation.self_realization?
    else
      render :prescreen
    end
  end

  def random
    redirect_to meditation_url(Meditation.get(:random)), status: :see_other
  end

  def find
    where = {}
    where[:duration_filter_id] = params[:duration_filter] if params[:duration_filter].present?
    where[:goal_filters] = { id: params[:goal_filter] } if params[:goal_filter].present?
    meditation = Meditation.joins(:goal_filters).where(where).order('RANDOM()').first
    raise ActiveRecord::RecordNotFound, 'No meditation found for the given filters' unless meditation.present?

    redirect_to meditation_url(meditation), status: :see_other
  end

end
