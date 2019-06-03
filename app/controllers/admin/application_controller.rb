module Admin
  # Basic controller that all other admin controllers inherit from.
  class ApplicationController < ::ApplicationController

    before_action :authenticate_user!
    after_action :verify_authorized, except: [:dashboard]

    def dashboard
    end

  end
end
