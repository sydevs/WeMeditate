class TracksController < ApplicationController

  def index
    @tracks = Track.includes_content.all
    @mood_filters = MoodFilter.includes(:translations).all
    @instrument_filters = InstrumentFilter.includes(:translations).all
    @static_page = StaticPage.includes_content.find_by(role: :tracks)
    @metatags = @static_page.get_metatags
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: @static_page.title }
    ]
  end

end
