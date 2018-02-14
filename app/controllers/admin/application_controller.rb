module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized, except: [:dashboard]
    skip_before_action :set_navigation

    def dashboard
    end
    
  end
end
  