class TracksController < ApplicationController

  def index
    @tracks = Track.published.preload_for(:content).all
    return unless stale?(@tracks)
    
    # @mood_filters = MoodFilter.published.has_content
    @instrument_filters = InstrumentFilter.published.has_content
    @static_page = StaticPage.preload_for(:content).find_by(role: :tracks)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name },
    ]

    set_metadata(@static_page)
  end

end
