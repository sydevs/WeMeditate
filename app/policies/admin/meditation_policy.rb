module Admin
  class MeditationPolicy < Admin::ApplicationPolicy

    def manage?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def update?
      update_translation? || update_structure?
    end

    def update_translation?
      return false unless can_access_locale?
      manage? || (translator? && needs_translation?)
    end

    def update_structure?
      (manage? && super_admin?) || (create? && record.new_record?)
    end

    def create?
      manage?
    end

    def publish?
      manage?
    end

    def review?
      publish?
    end

  end
end
