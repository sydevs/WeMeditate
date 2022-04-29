module Admin
  class PromoPagesController < Admin::ApplicationRecordController

    prepend_before_action { @model = PromoPage }

    def create
      super promo_page_params
    end

    def update
      super promo_page_params
    end

    protected

      def promo_page_params
        params.fetch(:promo_page, {}).permit(:state, :name, :slug, :owner_id, :content, metatags: {})
      end

  end
end
