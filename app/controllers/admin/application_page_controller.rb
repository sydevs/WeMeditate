module Admin
  class ApplicationPageController < Admin::ApplicationController
    before_action :set_paper_trail_whodunnit
    before_action :set_page, except: [:index, :create, :new]
    before_action :authorize!, except: [:create]

    def index
      pages_name = @klass.name.pluralize.underscore
      instance_variable_set('@'+pages_name, @klass.all)
    end

    def show
      #redirect_to [:edit, :admin, @page]
    end

    def new
      @page = @klass.new
      set_instance_variable
    end

    def edit
    end

    def create page_params
      @page = @klass.new update_params(page_params)
      set_instance_variable
      authorize @page

      if @page.save
        @page.publish_drafts! if @page.has_paper_trail? # This line effectively disables drafts by always publishing the latest version.
        redirect_to [:edit, :admin, @page], flash: { info: "Created successfully." }
      else
        render :new
      end
    end

    def update page_params
      @page.attributes = update_params(page_params)

      if @page.save
        @page.publish_drafts! if @page.has_paper_trail? # This line effectively disables drafts by always publishing the latest version.

        #redirect_to [:edit, :admin, @page]
        if policy(@page).review?
          redirect_to [:admin, @page], flash: { info: "Saved successfully, you can now review and publish the changes." }
        else
          redirect_to [:edit, :admin, @page], flash: { info: "Saved successfully." }
        end
      else
        render :edit
      end
    end

    def destroy
      if @page.translated_locales.include? I18n.locale
        if @page.translated_locales.count == 1
          @page.destroy
        else
          @page.translations.find_by(locale: I18n.locale).delete
          @page.sections.where(language: I18n.locale).delete_all
        end
      end

      render 'admin/application_pages/destroy'
    end

    def upload_media
      file = params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile) ? params[:qqfile] : params[:file]
      attachment = @page.attachments.new uuid: params[:qquuid], size: params[:qqtotalfilesize], name: params[:qqfilename], file: file

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
      @page.attachments.find_by(uuid: params[:qquuid]).delete
      render json: {
        success: true,
        uuid: params[:qquuid],
      }
    end

    def review
      if params[:do] == 'publish'
        @page.publish_drafts!
      else
        @page.discard_drafts!
      end

      redirect_to [:admin, @klass]
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

      def set_model klass
        @klass = klass
      end

      def update_params page_params
        if page_params[:sections_attributes].present?
          #page_params = page_params.to_h
          page_params[:sections_attributes].each do |key, data|
            if data[:extra].present? and data[:extra][:items].present?
              data = data[:extra][:items]
              data = data.values.transpose.map { |vs| data.keys.zip(vs).to_h }
              page_params[:sections_attributes][key][:extra][:items] = data
            end
          end
        end

        page_params
      end

    private
      def set_page
        @page = @klass.includes(:sections).friendly.find(params[:id])
        set_instance_variable
      end

      def set_instance_variable
        page_name = @klass.name.underscore
        instance_variable_set('@'+page_name, @page)
      end

      def authorize!
        authorize @page || @klass
      end

  end
end
