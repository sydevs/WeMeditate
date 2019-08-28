class Users::InvitationsController < Devise::InvitationsController
  
  skip_before_action :enfore_maintenance_mode
  
end