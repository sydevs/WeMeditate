class MeditationsController < ApplicationController

  MEDITATIONS_PER_PAGE = 10

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    expires_in 12.hours, public: true

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

  def archive
    next_offset = params[:offset].to_i + MEDITATIONS_PER_PAGE
    @meditations = Meditation.published.preload_for(:preview).offset(params[:offset]).limit(MEDITATIONS_PER_PAGE)
    return unless stale?(@meditations)

    set_metadata({ 'title' => Meditation.model_name.human(count: -1) })

    if @meditations.count < next_offset
      @loadmore_url = nil
    else
      @loadmore_url = archive_meditations_path(format: 'js', offset: next_offset)
    end

    respond_to do |format|
      format.html do
        @breadcrumbs = [
          { name: StaticPageHelper.preview_for(:home).name, url: root_path },
          { name: StaticPageHelper.preview_for(:meditations).name, url: meditations_path },
          { name: Meditation.model_name.human(count: -1), url: archive_meditations_path },
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
      # TODO: This should be changed to be less naive, and actually check when people view the video.
      @meditation.update! views: @meditation.views + 1
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

  def record_view
    meditation = Meditation.friendly.find(params[:id])
    meditation.update! views: meditation.views + 1
  end

end
