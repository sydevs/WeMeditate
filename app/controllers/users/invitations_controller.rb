class Users::InvitationsController < Devise::InvitationsController
  def default_url_options
    { host: Rails.configuration.admin_host }
  end
  
  skip_before_action :enfore_maintenance_mode
  
end