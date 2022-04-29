module Admin
  class PromoPagePolicy < Admin::ApplicationPolicy

    def update?
      return false unless can_access_locale?
      return true if admin?
      return true if editor?
      return true if writer? && owns_record?
      return false
    end

    def create?
      return false unless can_access_locale?
      return true if admin?
      return true if editor?
      return false
    end

    def publish?
      return false unless can_access_locale?
      return true if admin?
      return true if editor?
      return true if writer? && owns_record?
      return false
    end

    def review?
      publish?
    end

  end
end
