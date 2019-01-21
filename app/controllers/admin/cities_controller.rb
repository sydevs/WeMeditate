module Admin
  class CitiesController < Admin::ApplicationRecordController
    include RequiresApproval
    skip_before_action :set_record, only: [:lookup]

    prepend_before_action do
      set_model City
    end

    def new
      super
      @record.generate_default_sections!
    end

    def create
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

      respond_to do |format|
        format.json { render json: { results: json }, status: :ok }
      end
    end

    protected
      def city_params
        city_params = params.fetch(:city, {}).permit(
          :country, :name, :slug, :address, :latitude, :longitude, :banner_id,
          contacts: {}, metatags: {},
        )

        if city_params[:contacts].present?
          data = city_params[:contacts]
          city_params[:contacts] = data.values.transpose.map { |vs| data.keys.zip(vs).to_h }
        end

        city_params
      end

  end
end
