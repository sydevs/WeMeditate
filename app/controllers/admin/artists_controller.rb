module Admin
    class ArtistsController < Admin::ApplicationResourceController
      prepend_before_action do
        set_model Artist
      end
  
      def create
        super artist_params
      end
  
      def update
        super artist_params
      end
  
      def destroy
        if @artist.tracks.count > 0
          redirect_to [:admin, Artist], alert: 'You cannot delete a artist which has tracks attached to it. Reassign the tracks and try again.'
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
  