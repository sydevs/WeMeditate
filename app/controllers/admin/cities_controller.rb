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
      def city_params
        params.fetch(:city, {}).permit(
          :name, :latitude, :longitude, :banner,
          sections_attributes: [
            :id, :order, :_destroy, # Meta fields
            :header, :content_type, :visibility_type, :visibility_countries,
            :text, :youtube_id, :image # These are the options for different content_types
          ]
        )
      end

  end
end
  