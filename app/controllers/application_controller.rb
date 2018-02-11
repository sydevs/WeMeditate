class ApplicationController < ActionController::Base
  include Regulator
  protect_from_forgery
  #protect_from_forgery with: :exception

  def front
  end

  protected
    #def url_options
    #  { locale: I18n.locale }.merge(super)
    #end
    
    def layout_by_resource
      if devise_controller?
        'devise'
      else
        'application'
      end
    end

end
