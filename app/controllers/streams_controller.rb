class StreamsController < ApplicationController

  def index
    @stream = Stream.for_time_zone(Time.zone)
    @streams = Stream.publicly_visible.preload_for(:content)

    return raise ActionController::RoutingError.new('Not Found') unless @stream.present?    
    return unless stale?(@streams) || stale?(@stream)

    @splash_style = :stream
    set_metadata(@stream)
  end

  def show
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
