class TracksController < ApplicationController

  def index
    @tracks = Track.preload_for(:content).all
    @mood_filters = MoodFilter.includes(:translations).all
    @instrument_filters = InstrumentFilter.includes(:translations).all
    @static_page = StaticPage.preload_for(:content).find_by(role: :tracks)
    @metadata_record = @static_page
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name },
    ]
  end

end
