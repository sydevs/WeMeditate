class MeditationsController < ApplicationController

  MEDITATIONS_PER_PAGE = 10

  def index
    @record = StaticPage.preload_for(:content).find_by(role: :meditations)

    # TODO: Deprecated
    @static_page = @record
    @metadata_record = @static_page

    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @record.name },
    ]

    if params[:prescreen] == 'false'
      @meditations = Meditation.preload_for(:preview).all
      @goal_filters = GoalFilter.includes(:translations).all
      @duration_filters = DurationFilter.all
    else
      render :prescreen
    end
  end

  def archive
    next_offset = params[:offset].to_i + MEDITATIONS_PER_PAGE
    @meditations = Meditation.preload_for(:preview).offset(params[:offset]).limit(MEDITATIONS_PER_PAGE)

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
    @meditation = Meditation.friendly.find(params[:id])
    @metadata_record = @meditation

    # Increment the view counter for this page.
    # TODO: This should be changed to be less naive, and actually check when people view the video.
    @meditation.update! views: @meditation.views + 1

    meditations_page = StaticPage.preload_for(:content).find_by(role: :meditations)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: meditations_page.name, url: meditations_path },
      { name: @meditation.name },
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
    raise ActiveRecord::RecordNotFound, 'No meditation found for the given filters' unless meditation.present?

    redirect_to meditation_url(meditation), status: :see_other
  end

  def record_view
    meditation = Meditation.friendly.find(params[:id])
    meditation.update! views: meditation.views + 1
  end

end
