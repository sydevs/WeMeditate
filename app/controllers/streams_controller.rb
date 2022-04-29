class StreamsController < ApplicationController

  before_action :set_cache_headers

  def index
    time_zone = ActiveSupport::TimeZone.new(request.location.data['timezone']) rescue Time.zone
    @stream = Stream.public_stream.preload_for(:content).for_time_zone(time_zone)
    @streams = Stream.public_stream.preload_for(:preview)

    return raise ActionController::RoutingError.new('Not Found') unless @stream.present?    
    #return unless stale?(@streams) || stale?(@stream)

    @splash_style = :stream
    set_metadata(@stream)
  end

  def show
    time_zone = ActiveSupport::TimeZone.new(request.location.data['timezone']) rescue Time.zone
    @stream = Stream.public_stream.preload_for(:content).friendly.find(params[:id])
    return if redirect_legacy_url(@stream)
    
    #return unless stale?(@stream)

    @breadcrumbs = [
      #{ name: StaticPage.preview(:home).name, url: root_path },
      { name: StaticPage.preview(:streams).name, url: streams_path },
      { name: @stream.name },
    ]

    @splash_style = :stream
    set_metadata(@stream)
  end

  private

    def set_cache_headers
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
    end
    
end
