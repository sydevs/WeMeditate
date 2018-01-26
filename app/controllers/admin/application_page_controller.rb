module Admin
  class ApplicationPageController < Admin::ApplicationController
    before_action :set_page, except: [:index, :create, :new]
    before_action :authorize!, except: [:create]

    def index
      pages_name = @klass.name.pluralize.underscore
      instance_variable_set('@'+pages_name, @klass.all)
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
        redirect_to [:admin, @klass]
      else
        render :new
      end
    end

    def update page_params
      if params[:reset_slug]
        page_params.merge slug: nil
      end

      if @page.update page_params
        #redirect_to edit_admin_article_path(@article)
        redirect_to [:admin, @klass]
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

    protected
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
