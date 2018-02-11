class TracksController < ApplicationController

    def index
      @tracks = Track.all
      @mood_filters = MoodFilter.all
      @instrument_filters = InstrumentFilter.all
    end
    
  end
  