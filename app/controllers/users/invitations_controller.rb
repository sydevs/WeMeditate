class Users::InvitationsController < Devise::InvitationsController
  def default_url_options
    { host: Rails.configuration.admin_domain }
  end
  
  skip_before_action :enfore_maintenance_mode
  
end