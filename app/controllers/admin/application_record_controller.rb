module Admin
  class ApplicationRecordController < Admin::ApplicationController
    before_action :set_record, only: [:show, :edit, :update, :destroy]
    before_action :authorize!, except: [:create]

    def index
      @records = @model.q(params[:q]).page(params[:page]).all
      render 'admin/application/index'
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

    def create record_params
      @record = @model.new update_params(record_params)
      authorize @record

      if @record.save
        redirect_to [:edit, :admin, @record], flash: { notice: t('messages.result.created') }
      else
        render :new
      end
    end

    def update page_params, redirect = nil
      @record.attributes = update_params(page_params)
      allow = policy(@record)
      redirect = (allow.show? ? [:admin, @record] : [:admin, @model]) if redirect.nil?

      if @record.valid?
        if allow.publish? and params[:draft] != 'true'
          @record.published_at = DateTime.now if @record.respond_to? :published_at
          @record.draft = nil
          @record.save!
          redirect_to redirect, flash: { notice: t('messages.result.updated') }
        else
          @record.record_draft!
          @record.save!
          redirect_to redirect, flash: { notice: t('messages.result.saved_but_needs_review') }
        end
      else
        render :edit
      end
    end

    def destroy
      if @record.translatable? and @record.translated_locales.include? I18n.locale
        if @record.translated_locales.count == 1
          @record.destroy
        else
          @record.translations.find_by(locale: I18n.locale).delete
          @record.sections.where(language: I18n.locale).delete_all
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
      def set_model model
        @model = model
      end

      def update_params record_params
        if record_params[:sections_attributes].present?
          #record_params = record_params.to_h
          record_params[:sections_attributes].each do |key, data|
            if data[:extra].present? and data[:extra][:items].present?
              data = data[:extra][:items]
              data = data.values.transpose.map { |vs| data.keys.zip(vs).to_h }
              record_params[:sections_attributes][key][:extra][:items] = data
            end
          end
        end

        if record_params[:metatags].present?
          record_params[:metatags] = record_params[:metatags][:keys].zip(record_params[:metatags][:values]).to_h
        end

        record_params
      end

    private
      def set_record
        if defined? @model.friendly
          @record = @model.preload_for(:admin).friendly.find(params[:id])
        else
          @record = @model.preload_for(:admin).find(params[:id])
        end
      end

      def authorize!
        authorize @record || @model
      end

  end
end
