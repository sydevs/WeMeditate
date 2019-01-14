module Admin
  class ArticlesController < Admin::ApplicationRecordController
    include HasContent, RequiresApproval

    prepend_before_action do
      set_model Article
    end

    def create
      super article_params
    end

    def update
      super article_params
    end

    protected
      def article_params
        if policy(@article || Article).update_structure?
          params.fetch(:article, {}).permit(
            :name, :slug, :category_id, :priority, :excerpt, :banner_uuid, :thumbnail_uuid, :video_uuid, :date,
            sections_attributes: ALL_SECTION_ATTRIBUTES,
            metatages: {}
          )
        else
          params.fetch(:article, {}).permit(
            :name, :slug, :excerpt, :banner_uuid, :thumbnail_uuid, :video_uuid,
            sections_attributes: TRANSLATABLE_SECTION_ATTRIBUTES
          )
        end
      end

  end
end
