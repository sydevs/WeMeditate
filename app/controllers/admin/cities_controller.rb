module Admin
  class CitiesController < Admin::ApplicationPageController
    skip_before_action :set_page, only: [:lookup]
    prepend_before_action do
      set_model City
    end

    def create
      super city_params
    end

    def update
      super city_params
    end
    
    def lookup
      results = Geocoder.search(params[:q]) # TODO: Switch to :google_places_search

      json = results.collect do |result|
        {
          title: [result.city, result.state_code, result.country].reject(&:blank?).join(', '),
          city_name: result.city,
          latitude: result.latitude,
          longitude: result.longitude,
        }
      end

      respond_to do |format|
        format.json { render json: { results: json }, status: :ok }
      end
    end

    protected
      ALLOWED_PROGRAM_TIME_ATTRIBUTES = [
        :id, :_destroy, # Meta fields
        :day_of_week, :start_time, :end_time,
      ]
      
      ALL_PROGRAM_VENUE_ATTRIBUTES = [
        :id, :order, :_destroy, # Meta fields
        :address, :room_information,
        :order, :latitude, :longitude,
        program_times_attributes: ALLOWED_PROGRAM_TIME_ATTRIBUTES,
      ]
      
      TRANSLATABLE_PROGRAM_VENUE_ATTRIBUTES = [
        :id, # Meta fields
        :room_information,
      ]

      def city_params
        if policy(@city || City).update_structure?
          params.fetch(:article, {}).permit(
            :name, :slug, :address, :latitude, :longitude, :banner,
            sections_attributes: Admin::ApplicationPageController::ALL_SECTION_ATTRIBUTES,
            program_venues_attributes: ALL_PROGRAM_VENUE_ATTRIBUTES,
          )
        else
          params.fetch(:article, {}).permit(
            sections_attributes: Admin::ApplicationPageController::TRANSLATABLE_SECTION_ATTRIBUTES,
            program_venues_attributes: TRANSLATABLE_PROGRAM_VENUE_ATTRIBUTES,
          )
        end
      end

  end
end
  