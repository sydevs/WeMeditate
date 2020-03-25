class StreamsController < ApplicationController

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :streams)
    @countdown_time = Time.now.monday.next_week.change(hour: 20)
    seconds_diff = (@countdown_time - Time.now).to_i
    @live = params[:live] || seconds_diff.negative?

    if @live
      @stream_url = "https://player.twitch.tv/?channel=wemeditate&parent=#{request.host}"
    else
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
