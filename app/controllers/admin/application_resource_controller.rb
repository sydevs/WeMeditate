module Admin
    class ApplicationResourceController < Admin::ApplicationController
      before_action :set_resource, except: [:index, :create, :sort]
      before_action :authorize!, except: [:create]

      def index
        resources_name = @klass.name.pluralize.underscore
        instance_variable_set('@'+resources_name, @klass.all)
      end

      def show
        redirect_to [:edit, @klass]
      end

      def create resource_params
        @resource = @klass.new resource_params
        set_instance_variable
        authorize @resource
        @resource.save
        render 'admin/application_resources/create'
      end

      def update resource_params
        @resource.update resource_params
        render 'admin/application_resources/update'
      end

      def destroy
        @resource.destroy
        render 'admin/application_resources/destroy'
      end

      protected
        def set_model klass
          @klass = klass
        end

        def set_resource
          @resource = @klass.find(params[:id])
          set_instance_variable
        end

        def set_instance_variable
          resource_name = @klass.name.underscore
          instance_variable_set('@'+resource_name, @resource)
        end

      private
        def authorize!
          authorize @resource || @klass
        end

    end
  end
