class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Regulator
  protect_from_forgery #with: :exception

  def front
  end

  protected
    def layout_by_resource
      if devise_controller?
        'devise'
      else
        'application'
      end
    end

    def meditations_navigation
    end


end

class Hash
  def method_missing(name, *args, &blk)
    if self.keys.map(&:to_sym).include? name.to_sym
      return self[name.to_sym]
    else
      super
    end
  end
end
