module Admin
  class ApplicationPolicy < ::ApplicationPolicy

    def index?
      update? || create? || destroy?
    end
    
    def update?
      super_admin?
    end

    def create?
      super_admin?
    end

    def destroy?
      super_admin?
    end

    

    def super_admin?
      user.super_admin?
    end
  
    def regional_admin?
      user.regional_admin? or super_admin?
    end
  
    def editor?
      user.editor? or regional_admin?
    end
  
    def locale_allowed?
      user.available_languages.include? I18n.locale
    end
    
  end
end
