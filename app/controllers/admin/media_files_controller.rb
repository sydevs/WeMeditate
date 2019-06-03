module Admin
  class MediaFilesController < Admin::ApplicationController

    before_action :set_parent, only: %i[index create]
    before_action :authorize!

    def index
      @media_files = @parent.media_files.page(params[:page]).all
    end

    def create
      @media_file = @parent.media_files.create! media_file_params
      render json: { id: @media_file.id, preview: @media_file.file.small.url }.to_json
    end

    def trash
      @media_files = MediaFile.where(usage_count: 0)
    end

    def clean
      MediaFile.where(usage_count: 0).destroy_all
      redirect_to admin_media_files_path, flash: { notice: translate('messages.result.deleted') }
    end

    protected

      def media_file_params
        params.permit(:name, :file)
      end

      def set_parent
        if params[:article_id].present?
          @parent = Article.friendly.find(params[:article_id])
        elsif params[:static_page_id].present?
          @parent = StaticPage.friendly.find(params[:static_page_id])
        elsif params[:subtle_system_node_id].present?
          @parent = SubtleSystemNode.friendly.find(params[:subtle_system_node_id])
        end
      end

      def authorize!
        authorize MediaFile
      end

  end
end
