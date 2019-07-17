module Admin
  class ArtistsController < Admin::ApplicationRecordController

    prepend_before_action { @model = Artist }

    def create
      super artist_params
    end

    def update
      super artist_params
    end

    def destroy
      super associations: %i[tracks]
    end

    private

      def artist_params
        params.fetch(:artist, {}).permit(:name, :url, :image)
      end

  end
end
