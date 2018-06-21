module Admin
  class CitiesController < Admin::ApplicationPageController
    skip_before_action :set_page, only: [:lookup]
    prepend_before_action do
      set_model City
    end

    def new
      super
      @city.generate_default_sections!
    end

    def create
      puts city_params
      super city_params
    end

    def update
      super city_params
    end

    def lookup
      lookup_params = { types: params[:type], language: I18n.locale }
      #params << { country: @city.country } if @city.country.present?
      results = Geocoder.search(params[:q], params: lookup_params) # TODO: Switch to :google_places_search

      json = results.collect do |result|
        result.data['formatted_address'] = "#{result.data['name']}, #{result.data['formatted_address']}" unless result.data['formatted_address'].starts_with?(result.data['name'])

        {
          title: result.data['formatted_address'],
          name: result.data['name'],
          latitude: result.latitude,
          longitude: result.longitude,
        }
      end

      puts "RESULTS #{results.pretty_inspect}"
      puts "JSON #{json.pretty_inspect}"

      respond_to do |format|
        format.json { render json: { results: json }, status: :ok }
      end
    end

    protected
      def city_params
        if policy(@city || City).update_structure?
          params.fetch(:city, {}).permit(
            :country, :name, :slug, :address, :latitude, :longitude, :banner,
            sections_attributes: Admin::ApplicationPageController::ALL_SECTION_ATTRIBUTES,
            venues: {},
          )
        else
          params.fetch(:city, {}).permit(
            sections_attributes: Admin::ApplicationPageController::TRANSLATABLE_SECTION_ATTRIBUTES,
          )
        end
      end

      def update_params city_params
        puts "BEFORE TRANSFORM #{city_params[:venues].inspect}"

        if city_params[:venues].present?
          city_params = city_params.to_h
          data = city_params[:venues]
          data = data.values.transpose.map { |vs| data.keys.zip(vs).to_h }
          city_params[:venues] = data
        end

        puts "AFTER TRANSFORM #{city_params[:venues].inspect}"

        super city_params
      end

  end
end
