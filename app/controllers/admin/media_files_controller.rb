module Admin
  class MediaFilesController < Admin::ApplicationController

    def create
      if params[:article_id].present?
        @parent = Article.friendly.find(params[:article_id])
      elsif params[:static_page_id].present?
        @parent = StaticPage.friendly.find(params[:static_page_id])
      elsif params[:subtle_system_node_id].present?
        @parent = SubtleSystemNode.friendly.find(params[:subtle_system_node_id])
      elsif params[:stream_id].present?
        @parent = Stream.friendly.find(params[:stream_id])
      end

      authorize @parent, :upload?
      @media_file = @parent.media_files.create! params.permit(:file)
      render json: { id: @media_file.id, preview: @media_file.file.small.url }.to_json
    end

  end
end
