class StreamsController < ApplicationController

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :streams)
    @countdown_time = countdown_target_time
    @current_time = current_time
    seconds_diff = (@countdown_time - current_time).to_i

    if params[:live] == 'true'
      @live = true
    elsif params[:live] == 'false'
      @live = false
    else
      @live = seconds_diff < 5.minutes
    end

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

  private

    def countdown_target_time
      countdown_time = next_stream_time(current_date)
      if current_time > countdown_time + 1.hour
        countdown_time = next_stream_time(current_date + 1.day)
      end
      countdown_time
    end

    def current_time
      Time.zone.now
    end

    def current_date
      current_time.to_date
    end

    def next_stream_time date
      if date.saturday? || date.sunday?
        date = date.monday
        date = date.next_week if date < current_time.to_date
      end

      date.to_time.change(hour: 19)
    end

end
