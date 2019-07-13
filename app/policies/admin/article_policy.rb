module Admin
  class ArticlePolicy < Admin::ApplicationPolicy

    def update?
      update_structure? || update_translation?
    end

    def update_translation?
      return false unless can_access_locale?
      return true if translator?
      return true if editor? && owns_record?
      return true if admin?
      return false
    end

    def update_structure?
      update_translation? && !translator?
    end

    def create?
      return false unless can_access_locale?
      return true if editor?
      return true if admin?
      return false
    end

    def publish?
      return false unless can_access_locale?
      return true if editor? && owns_record?
      return true if admin?
      return false
    end

    def review?
      publish?
    end

  end
end
