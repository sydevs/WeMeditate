module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

  def assignable_roles
    case current_user.role
    when 'super_admin'
      User.roles
    when 'regional_admin'
      User.roles.except(:super_admin, :regional_admin)
    else
      []
    end
  end

end
