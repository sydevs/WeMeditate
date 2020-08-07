class Users::InvitationsController < Devise::InvitationsController
  
  skip_before_action :enforce_maintenance_mode
  prepend_before_action :set_locale!

  def set_locale!
    I18n.locale = params[:locale]&.to_sym || :en
  end

  def default_url_options
    { host: Rails.configuration.admin_host }
  end
  
end