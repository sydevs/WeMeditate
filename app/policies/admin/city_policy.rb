module Admin
  class CityPolicy < ApplicationPolicy

    def index?
      editor? and locale_allowed?
    end
    
    def update?
      editor? and locale_allowed?
    end

    def create?
      editor? and locale_allowed?
    end

    def destroy?
      super_admin?
    end

    def lookup?
      update? || create?
    end
  end
end
  