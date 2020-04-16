module Admin
  class StaticPagePolicy < Admin::ApplicationPolicy

    def update?
      update_structure? || update_translation?
    end

    def update_translation?
      return false unless can_access_locale?
      return true if admin? || editor?
      return true if translator? && can_translate? # This call is a bit more costly
      return false
    end

    def update_structure?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def create?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def publish?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def review?
      publish?
    end

    def destroy?
      record.custom?
    end

  end
end
