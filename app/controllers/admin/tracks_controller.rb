module Admin
  class TracksController < Admin::ApplicationController
    before_action :set_track, except: [:index, :create]
    before_action :authorize!, except: [:create]

    def index
      @tracks = Track.all
    end

    def create
      @track = Track.new track_params
      authorize @track
      @track.save

      if @track.errors.empty?
        redirect_to [:admin, Track]
      else
        redirect_to [:admin, Track], alert: @track.errors.messages
      end
    end

    def update
      if @track.update track_params
        redirect_to [:admin, Track]
      else
        respond_to do |format|
          format.json { render json: @track.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @track.destroy
      redirect_to [:admin, Track]
    end

    private
      def track_params
        params.fetch(:track, {}).permit(:title, :subtitle, :file, mood_filter_ids: [], instrument_filter_ids: [])
      end

      def set_track
        @track = Track.find(params[:id])
      end

      def authorize!
        authorize @track || Track
      end

  end
end
