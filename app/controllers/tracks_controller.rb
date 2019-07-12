class TracksController < ApplicationController

  def index
    @tracks = Track.published.preload_for(:content).all
    # @mood_filters = MoodFilter.published.has_content
    @instrument_filters = InstrumentFilter.published.has_content
    @static_page = StaticPage.preload_for(:content).find_by(role: :tracks)
    @metadata_record = @static_page
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name },
    ]
  end

end
