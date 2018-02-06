module Admin
  class UserPolicy < Admin::ApplicationResourcePolicy

    def index?
      editor? and locale_allowed?
    end

    def update?
      if super_admin?
        true
      elsif regional_admin? and locale_allowed?
        not (record.regional_admin? or record.super_admin?)
      else
        false
      end
    end

    def create?
      regional_admin? and locale_allowed?
    end

  end
end
