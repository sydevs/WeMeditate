module Admin
  class ApplicationRecordController < Admin::ApplicationController

    before_action :set_record, only: %i[show edit write update destroy]
    before_action :authorize!, except: %i[create]

    def index
      respond_to do |format|
        format.html do
          @records = @model.q(params[:q]).page(params[:page]).all
          render 'admin/application/index'
        end

        format.json do
          render json: @model.select(:id, :name).q(params[:q]).to_json(only: %i[id name])
        end
      end
    end

    def show
      render 'admin/application/show'
    end

    def new
      @record = @model.new
      render 'admin/application/new'
    end

    def edit
      render 'admin/application/edit'
    end

    def write
      render 'admin/application/write'
    end

    def create record_params, redirect = nil
      @record = @model.new update_params(record_params)
      authorize @record

      if @record.save
        redirect_to (redirect || [:edit, :admin, @record]), flash: { notice: t('messages.result.created') }
      else
        render :new
      end
    end

    def update page_params, redirect = nil
      @record.attributes = update_params(page_params)
      allow = policy(@record)
      will_publish = allow.publish? and params[:draft] != 'true'
      # redirect = (allow.show? ? [:admin, @record] : [:admin, @model]) if redirect.nil?
      redirect = [(page_params[:content].present? ? :write : :edit), :admin, @record] if redirect.nil?

      if will_publish
        @record.published_at = Time.now.to_date if @record.respond_to? :published_at
        @record.consolidate_media_files! if @record.has_content?
        @record.discard_draft!
      else
        @record.record_draft!
      end

      if @record.save
        redirect_to redirect, flash: {
          notice: will_publish ? t('messages.result.updated') : t('messages.result.saved_but_needs_review'),
        }
      else
        render :edit
      end
    end

    def destroy
      if @record.translatable? and @record.translated_locales.include? I18n.locale
        if @record.translated_locales.count == 1
          @record.destroy
        else
          @record.translations.find_by(locale: I18n.locale).destroy_all
        end
      else
        @record.destroy
      end

      render 'admin/application/destroy'
    end

    def sort
      params[:order].each_with_index do |id, index|
        @model.find(id).update_attribute(:order, index)
      end

      redirect_to [:admin, @model]
    end

    protected

      def update_params record_params
        if record_params[:metatags].present?
          record_params[:metatags] = record_params[:metatags][:keys].zip(record_params[:metatags][:values]).to_h
        elsif @model.column_names.include? 'metatags'
          record_params[:metatags] = []
        end

        record_params
      end

    private

      def set_record
        @record = begin
          if defined? @model.friendly
            @model.preload_for(:admin).friendly.find(params[:id])
          else
            @model.preload_for(:admin).find(params[:id])
          end
        end
      end

      def authorize!
        authorize @record || @model
      end

  end
end
