class ApplicationController < ActionController::Base
  include Regulator
  protect_from_forgery #with: :exception
  before_action :set_navigation

  def front
  end

  protected
    def set_navigation
      @desktop_navigation = [
        { title: 'Why Meditate', label: 'Why', url: root_url },
        { title: 'How to meditate', label: 'How', url: root_url },
        { title: 'Inspiration', url: categories_url },
        { title: 'Music', url: tracks_url },
        { title: 'Send inquiry', url: root_url },
        { title: 'Contacts', url: root_url },
      ]

      @mobile_navigation = [
        { title: 'Meditation', url: root_url },
        { title: 'Music', url: tracks_url },
        { title: 'Inspiration', url: categories_url },
        { title: 'Events', url: categories_url },
        { title: 'About us', url: root_url },
        { title: 'Contacts', url: root_url },
      ]
    end

    def layout_by_resource
      if devise_controller?
        'devise'
      else
        'application'
      end
    end

end
