class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Regulator
  protect_from_forgery #with: :exception
  before_action :set_navigation

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

  private
    def set_navigation
      @desktop_navigation = [
        {
          title: 'How much time do you have?', label: 'Meditate now!', url: meditations_url,
          content: { items: DurationFilter.first(5).reverse, featured: Meditation.first(2) }
        },
        {
          title: 'Inspiration', url: articles_url,
          content: { items: Article.first(5), featured: Article.first(2) }
        },
        { title: 'Music', url: tracks_url },
        {
          title: 'Learn More', url: root_url,
          content: { items: StaticPage.where(role: [:sahaja_yoga, :shri_mataji, :kundalini, :subtle_system]), featured: Treatment.first(2) }
        },
      ]

      @mobile_navigation = [
        { title: 'Meditation', url: root_url },
        { title: 'Music', url: tracks_url },
        { title: 'Inspiration', url: articles_url },
        { title: 'Events', url: articles_url },
        { title: 'About us', url: root_url },
        { title: 'Contacts', url: root_url },
      ]
    end

    def meditations_navigation
    end


end
