module Admin
  class StaticPagePolicy < Admin::ApplicationPolicy

    def update?
      update_structure? || update_translation?
    end

    def update_translation?
      return false unless can_access_locale?
      return true if translator?
      return true if admin?
      return false
    end

    def update_structure?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def create?
      false
    end

    def publish?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def destroy?
      false
    end

  end
end
