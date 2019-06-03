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
      if @artist.tracks.present?
        redirect_to [:admin, Artist], alert: t('messages.result.cannot_delete_attached_record', model: Artist.model_name.human.downcase, association: Track.model_name.human(count: -1).downcase)
      else
        super
      end
    end

    private

      def artist_params
        params.fetch(:artist, {}).permit(:name, :url, :image)
      end

  end
end
