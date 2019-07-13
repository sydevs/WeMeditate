module Admin
  class TreatmentPolicy < Admin::ApplicationPolicy

    def manage?
      return false unless can_access_locale?
      return true if admin?
      return false
    end

    def update?
      manage?
    end

    def create?
      manage?
    end

    def publish?
      update?
    end

  end
end
