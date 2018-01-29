module Admin
    class StaticPagesController < Admin::ApplicationPageController
      prepend_before_action do
        set_model StaticPage
      end
  
      def create
        super static_page_params
      end
  
      def update
        super static_page_params
      end
  
      protected
        def static_page_params
          params.fetch(:static_page, {}).permit(
            :title, :role,
            sections_attributes: Admin::ApplicationPageController::ALLOWED_SECTION_ATTRIBUTES
          )
        end
  
    end
  end
  