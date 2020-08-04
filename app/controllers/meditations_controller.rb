class MeditationsController < ApplicationController

  before_action :redirect_meditation, except: %i[index self_realization]

  MEDITATIONS_PER_PAGE = 10

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    expires_in 12.hours, public: true

    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name },
    ]

    if true || cookies[:prescreen] == 'dismissed'
      set_metadata(@static_page)
      @meditations = Meditation.preload_for(:preview).all
      @goal_filters = GoalFilter.publicly_visible.has_content
      @duration_filters = DurationFilter.publicly_visible.has_content
    else
      kundalini = I18n.translate('meditations.prescreen.kundalini')
      title = I18n.translate('meditations.prescreen.title', kundalini: kundalini)
      set_metadata({ 'title' => title })
      render :prescreen
    end
  end

  # The self realization page has a special action so that it can be redirected to from other parts of the site.
  def self_realization
    @meditation = Meditation.publicly_visible.get(:self_realization)
    raise ActionController::RoutingError, 'Self Realization Page Not Found' if @meditation.nil?

    set_metadata(@meditation)
    render :show
  end

  # Displays an index of all meditations.
  def archive
    next_offset = params[:offset].to_i + MEDITATIONS_PER_PAGE
    @meditations = Meditation.publicly_visible.preload_for(:preview).offset(params[:offset]).limit(MEDITATIONS_PER_PAGE)
    return unless stale?(@meditations)

    if Meditation.publicly_visible.count <= next_offset
      @loadmore_url = nil
    else
      @loadmore_url = archive_meditations_path(format: 'js', offset: next_offset)
    end

    respond_to do |format|
      format.html do
        @breadcrumbs = [
          { name: StaticPageHelper.preview_for(:home).name, url: root_path },
          { name: StaticPageHelper.preview_for(:meditations).name, url: meditations_path },
          { name: translate('meditations.title'), url: archive_meditations_path },
          { name: translate('meditations.archive.title') },
        ]

        set_metadata({ 'title' => translate('meditations.title') })
        render :archive
      end

      format.js do
        render :archive
      end
    end
  end

  def show
    @meditation = Meditation.publicly_visible.friendly.find(params[:id])
    @prescreen = !browser.bot? && cookies[:prescreen] != 'dismissed'

    meditations_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: meditations_page.name, url: meditations_path },
      { name: @meditation.name },
    ]

    set_metadata(@meditation)

    if @prescreen
      render :prescreen
    else
      # Increment the view counter for this page.
      @meditation.update! views: @meditation.views + 1, popularity: @meditation.popularity + 1 unless @meditation.self_realization?
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

  def redirect_meditation
    @meditation = Meditation.friendly.find(params[:id])

    return redirect_to @meditation, status: :moved_permanently unless request.path == meditation_path(@meditation)
  end

end
