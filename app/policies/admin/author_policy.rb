module Admin
  class AuthorPolicy < Admin::ApplicationPolicy

    def manage?
      return false unless can_access_locale?
      return true if admin?
      return true if editor?
      return true if writer? && owns_record?
      return false
    end

    def index?
      return false unless can_access_locale?
      return true if admin?
      return true if editor?
      return true if translator?
      return false
    end

    def update?
      update_structure? || update_translation?
    end

    def update_structure?
      manage? || owns_record?
    end

    def update_translation?
      return true if translator? && needs_translation? # This call is a bit more costly
      return manage?
    end

    def create?
      manage?
    end

    def publish?
      manage?
    end

  end
end
