module Admin
    class ApplicationResourceController < Admin::ApplicationController
      before_action :set_resource, except: [:index, :create, :sort]
      before_action :authorize!, except: [:create]
  
      def index
        resources_name = @klass.name.pluralize.underscore
        instance_variable_set('@'+resources_name, @klass.all)
      end
  
      def create resource_params
        @resource = @klass.new resource_params
        set_instance_variable
        authorize @resource
        @resource.save
        redirect_to [:admin, @klass]
      end
  
      def update resource_params
        if @resource.update resource_params
          redirect_to [:admin, @klass]
        else
          respond_to do |format|
            format.json { render json: @resource.errors, status: :unprocessable_entity }
          end
        end
      end
  
      def destroy
        @resource.destroy
        redirect_to [:admin, @klass]
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
  