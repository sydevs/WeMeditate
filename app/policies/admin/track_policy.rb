module Admin
  class TrackPolicy < Admin::ApplicationPolicy

    def manage?
      return false unless can_access_locale?
      return true if super_admin?
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
