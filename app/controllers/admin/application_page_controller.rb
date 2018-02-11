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
      page_name = @klass.name.underscore
      instance_variable_set('@'+page_name, @klass.new)
    end

    def edit
    end

    def create page_params
      @page = @klass.new page_params
      set_instance_variable
      authorize @page

      if @page.save
        @page.publish_drafts! # This line effectively disables drafts by always publishing the latest version.
        redirect_to [:admin, @klass]
      else
        render :new
      end
    end

    def update page_params
      if policy(@page).update_structure? and page_params[:sections_attributes].present?
        page_params[:sections_attributes].each do |_, section|
          section[:format] = section[:format][section[:content_type]]
        end
      end

      @page.attributes = page_params

      if @page.save
        @page.publish_drafts! # This line effectively disables drafts by always publishing the latest version.

        #redirect_to [:edit, :admin, @page]
        if policy(@page).review?
          redirect_to [:admin, @page]
        else
          redirect_to [:admin, @klass]
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

      redirect_to [:admin, @klass]
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
      ALL_SECTION_ATTRIBUTES = [
        :id, :order, :_destroy, # Meta fields
        :content_type, :visibility_type, :visibility_countries,
        :title, :subtitle, :text, :quote, :credit, :image, :action_text, :url, # These are the options for different content_types
        { format: [ :text, :image, :action ], images: [] },
      ]

      TRANSLATABLE_SECTION_ATTRIBUTES = [
        :id, # Meta fields
        :title, :subtitle, :text, :quote, :credit, :credit_subtitle, :image, :action_text, :action_url, :video_url, # These are the options for different content_types
        { images: [] }, # For image uploads
      ]

      def set_model klass
        @klass = klass
      end

    private
      def set_page
        @page = @klass.friendly.find(params[:id])
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
