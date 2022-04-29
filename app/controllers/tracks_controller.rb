class TracksController < ApplicationController

  def index
    @tracks = Track.publicly_visible.preload_for(:content).all
    return unless stale?(@tracks)

    # @mood_filters = MoodFilter.publicly_visible.has_content
    @instrument_filters = InstrumentFilter.publicly_visible.has_content
    @static_page = StaticPage.preload_for(:content).find_by(role: :tracks)
    @breadcrumbs = [
      { name: StaticPage.preview(:home).name, url: root_path },
      { name: @static_page.name },
    ]

    set_metadata(@static_page)
  end

end
