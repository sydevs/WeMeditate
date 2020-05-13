class StreamsController < ApplicationController

  def index
    time_zone = ActiveSupport::TimeZone.new(request.location.data['timezone']) rescue Time.zone
    @location = request.location.data
    @time_zone = time_zone

    @stream = Stream.public_stream.preload_for(:content).for_time_zone(time_zone)
    @streams = Stream.public_stream.preload_for(:preview)

    return raise ActionController::RoutingError.new('Not Found') unless @stream.present?    
    return unless stale?(@streams) || stale?(@stream)

    @splash_style = :stream
    set_metadata(@stream)
  end

  def show
    time_zone = ActiveSupport::TimeZone.new(request.location.data['timezone']) rescue Time.zone
    @location = request.location.data
    @time_zone = time_zone

    @stream = Stream.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return unless stale?(@stream)

    @breadcrumbs = [
      #{ name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: StaticPageHelper.preview_for(:streams).name, url: streams_path },
      { name: @stream.name },
    ]

    @splash_style = :stream
    set_metadata(@stream)
  end

end
