module Admin
  class UserPolicy < ApplicationPolicy

    def index?
      editor? and locale_allowed?
    end
    
    def update?
      if super_admin?
        true
      elsif regional_admin? and locale_allowed?
        record.editor?
      else
        false
      end
    end

    def create?
      regional_admin? and locale_allowed?
    end

    def destroy?
      super_admin?
    end

  end
end
