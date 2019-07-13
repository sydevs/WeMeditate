module Admin
  class MeditationPolicy < Admin::ApplicationPolicy

    def manage?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def update?
      manage?
    end

    def publish?
      update?
    end

    def create?
      manage?
    end

  end
end
