module Admin
  class ApplicationRecordController < Admin::ApplicationController

    before_action :set_record, only: %i[show edit write update destroy preview review approve]
    before_action :authorize!, except: %i[create]

    def index
      @records = policy_scope(@model).order(updated_at: :desc).q(params[:q])
      #@records = @records.not_archived unless params[:q].present?
      @records = sort_by(@records, params[:sort])
      @records = filter_by(@records, params[:filter])

      respond_to do |format|
        format.html do
          @records = @records.page(params[:page]).per(10)
          render 'admin/application/index'
        end

        format.js do
          @records = @records.page(params[:page]).per(10)
          render 'admin/application/index'
        end

        format.json do
          render json: @records.limit(5).to_json(only: %i[id name])
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

      save!(:create, nil, redirect) do
        after_create
      end
    end

    def update record_params, redirect = nil
      save!(:update, update_params(record_params), redirect) do
        @record.try(:cleanup_media_files!)
      end
    end

    def review
      render 'admin/application/review', layout: 'admin/review'
    end

    def preview
      reify = reify == '' ? [] : params[:reify]&.split(',')
      @record.try(:reify_draft!, only: reify) unless params[:review] && !params[:excerpt]
      render 'admin/application/preview', layout: params[:excerpt] ? 'basic' : 'application'
    end

    def approve
      redirect = helpers.polymorphic_admin_path([:admin, (@record.contentable? ? @record : @model)])
      if params[:review] == 'destroy'
        @record.discard_draft!
      else
        review = JSON.parse(params[:review])
        @record.reify_draft! only: review['details'] if @record.has_draft?(:details)
        @record.approve_content_changes! review['content'] if @record.has_draft?(:content)
      end

      if @record.save!
        puts "CLEANUP DRAFT"
        @record.cleanup_draft!
        @record.save!
        @record.try(:cleanup_media_files!)
        redirect_to redirect, flash: { notice: translate('admin.result.updated') }
      else
        render 'admin/application/review', layout: 'application'
      end
    end

    def destroy associations: []
      associations.each do |key|
        if @record.send(key).present?
          associated_model = @model.reflect_on_association(key).class
          message = translate('admin.result.cannot_delete_attached_record', category: human_model_name(@model).downcase, pages: human_model_name(associated_model, :plural).downcase)
          redirect_to helpers.polymorphic_admin_path([:admin, @model]), alert: message
        end  
      end

      if @record.translatable? && @record.has_translation?
        if @record.translated_locales.count == 1
          @record.destroy
        else
          @record.translations.where(locale: I18n.locale).destroy_all
        end
      else
        @record.destroy
      end

      respond_to do |format|
        format.html { redirect_to helpers.polymorphic_admin_path([:admin, @model]), flash: { notice: translate('admin.result.deleted') } }
        format.js { render 'admin/application/destroy' }
      end
    end

    def sort
      params[:order].each_with_index do |id, index|
        @model.find(id).update_attribute(:order, index)
      end

      redirect_to helpers.polymorphic_admin_path([:admin, @model])
    end

    protected

      def save! action, record_params, redirect = nil, &block
        allow = policy(@record)
        @record.attributes = record_params if record_params.present?
  
        will_publish = allow.publish? && (!@record.draftable? || params[:draft] != 'true')
        will_validate = (will_publish || action == :create)
        notice = translate (action == :create ? 'created' : 'updated'), scope: %i[admin result]
        redirect = helpers.polymorphic_admin_path(allow.show? ? [:admin, @record] : [:admin, @model]) if redirect.nil?
  
        if @record.draftable?
          if will_publish
            @record.cleanup_draft!
          elsif action == :create
            @record.record_draft!(current_user, only: %i[published])
            notice = translate('admin.result.saved_but_needs_review')
          else
            @record.record_draft!(current_user)
            notice = translate('admin.result.saved_but_needs_review')
          end
        end

        if @record.save(validate: will_validate) && block.call != false
          flash.notice = notice
          redirect_to redirect
        else
          render action == :create ? :new : :edit
        end
      end

      def update_params record_params
        if record_params[:metatags].present?
          record_params[:metatags] = record_params[:metatags][:keys].zip(record_params[:metatags][:values]).to_h
        elsif @record.respond_to?(:metatags) && !record_params[:content].present?
          record_params[:metatags] = nil
        end

        record_params[:published] = record_params[:published].to_i.positive? if record_params[:published].present?
        record_params
      end

      def after_create
        true # Return success, since we didn't need to do anything
      end

    private

      def set_record
        @record = @model.preload_for(:admin).find(params[:id])
        instance_variable_set("@#{@record.model_name.param_key}", @record)
      end

      def authorize!
        authorize @record || @model
      end

      def sort_by relation, param
        return relation unless param.present?
        
        direction = param.ends_with?('_at') ? :desc : :asc
        relation = relation.with_translation if relation.translatable?
        relation.reorder(param => direction)
      end
  
      def filter_by relation, param
        return relation unless param.present?

        param = param.split(':')
        column = param[0]
        value = param[1]

        if column == 'status'
          args = value == 'needs_translation' ? [current_user] : []
          relation.respond_to?(value) ? relation.send(value, *args) : relation
        else
          relation.where(column => value)
        end
      end

  end
end
