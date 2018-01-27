module Admin
  class MoodFilterPolicy < ApplicationPolicy

    def index?
      regional_admin? and locale_allowed?
    end
    
    def update?
      regional_admin? and locale_allowed?
    end

    def create?
      super_admin?
    end

    def destroy?
      super_admin?
    end

    def sort?
      super_admin?
    end
  end
end
