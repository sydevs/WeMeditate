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
      manage?
    end

    def update_structure?
      manage? || (create? && record.new_record?)
    end

    def publish?
      update?
    end

    def create?
      manage?
    end

  end
end
