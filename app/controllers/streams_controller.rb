class StreamsController < ApplicationController

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :streams)
    @streams = Stream.publicly_visible.preload_for(:content)
    @stream = Stream.for_time_zone(Time.zone)

    return raise ActionController::RoutingError.new('Not Found') unless @stream.present?    
    return unless stale?(@streams) || stale?(@stream) || stale?(@static_page)

    @splash_style = :stream
    set_metadata(@static_page)
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
