class TracksController < ApplicationController

  def index
    @tracks = Track.all
    @mood_filters = MoodFilter.all
    @instrument_filters = InstrumentFilter.all
    @static_page = StaticPage.includes(:sections).find_by(role: :tracks)
    @metatags = @static_page.get_metatags
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: @static_page.title }
    ]
  end

end
