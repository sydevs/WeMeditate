
module HasContent
  extend ActiveSupport::Concern

  included do

  end

  def show
    render 'admin/application/show'
  end

  def upload_media
    file = params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile) ? params[:qqfile] : params[:file]
    attachment = @record.attachments.new uuid: params[:qquuid], size: params[:qqtotalfilesize], name: params[:qqfilename], file: file

    if attachment.save
      render json: {
        success: true,
        uuid: params[:qquuid],
        src: attachment.file_url,
      }
    else
      render json: attachment.errors.to_json
    end
  end

  def destroy_media
    @record.attachments.find_by(uuid: params[:qquuid]).delete
    render json: {
      success: true,
      uuid: params[:qquuid],
    }
  end

  protected
    CONTENT_ATTRIBUTES = [
      :title, :subtitle, :sidetext, :text, :quote, :credit, :url, :action, # These are the options for different content_types
      extra: {}, # For extra attributes sections
    ]

    ALL_SECTION_ATTRIBUTES = [
      :id, :label, :order, :_destroy, # Meta fields
      :content_type, :visibility_type, :visibility_countries, :format, # Structural fields
    ] + CONTENT_ATTRIBUTES

    TRANSLATABLE_SECTION_ATTRIBUTES = [
      :id, :label, # Meta fields
    ] + CONTENT_ATTRIBUTES


end
