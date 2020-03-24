class StreamsController < ApplicationController

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :streams)
    @countdown_time = Time.now.monday.next_week.change(hour: 20)
    @countdown_time = Time.now - 1.day
    seconds_diff = (@countdown_time - Time.now).to_i
    @live = seconds_diff.negative?

    unless @live
      @days = seconds_diff / 86400
      seconds_diff -= @days * 86400

      @hours = seconds_diff / 3600
      seconds_diff -= @hours * 3600

      @minutes = seconds_diff / 60
      seconds_diff -= @minutes * 60

      @seconds = seconds_diff
    end

    set_metadata(@static_page)
  end

end
