module Admin
  class StreamsController < Admin::ApplicationRecordController

    prepend_before_action { @model = Stream }

    def index
      @streams = policy_scope(@model).order(updated_at: :desc).where(locale: Globalize.locale).all
      @featured_streams = {}

      for i in -12..+14 do
        featured_streams = @streams.to_a.filter { |s| s.target_time_zones.include?(i) && s.published? }
        
        if featured_streams.length == 1
          @featured_streams[i] = featured_streams.first
        elsif featured_streams.length > 1
          featured_streams.each do |stream|
            if @featured_streams.key?(i)
              distance_to_stream = (stream.time_zone_offset - i).abs
              distance_to_other_stream = (@featured_streams[i].time_zone_offset - i).abs
              @featured_streams[i] = stream if distance_to_stream < distance_to_other_stream
            else
              @featured_streams[i] = stream
            end
          end
        end
      end

      render 'admin/special/streams_index'
    end

    def create
      super stream_params
    end

    def update
      super stream_params
    end

    def write
      @splash_style = :stream
    end

    protected

      def stream_params
        params.fetch(:stream, {}).permit(
          :name, :slug, :excerpt, :state, :thumbnail_id, :content,
          :location, :time_zone, :target_time_zones, :stream_url,
          :start_date, :start_time, :end_time,
          recurrence: {},
          metatags: {}
        )
      end

      def update_params record_params
        if defined?(@record) && params[:stream][:thumbnail].present?
          record_params[:thumbnail_id] = @record.media_files.create!(file: params[:stream][:thumbnail]).id
        end

        if record_params[:target_time_zones].present?
          record_params[:target_time_zones] = record_params[:target_time_zones].split(',').map(&:to_i).compact
        end

        if record_params[:recurrence].present?
          record_params[:recurrence] = record_params[:recurrence].values.compact
        end

        super record_params
      end

      def after_create
        return unless params[:stream][:thumbnail]

        media_file = @record.media_files.create!(file: params[:stream][:thumbnail])
        @record.thumbnail_id = media_file.id
        @record.save!(validate: @record.published?)
      end

  end
end
