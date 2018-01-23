class ApplicationController < ActionController::Base
  include Regulator
  protect_from_forgery
  #protect_from_forgery with: :exception

  before_action :set_locale
 
  def front
  end

  protected
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options(options = {})
      { locale: I18n.locale }.merge options
    end

end
