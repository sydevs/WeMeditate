module Admin
  class UserPolicy < Admin::ApplicationPolicy

    class Scope < Scope
      def resolve
        scope.for_locale
      end
    end

    def manage?
      return false unless can_access_locale?
      return true if super_admin?
      return true if regional_admin? && user_record_is_subordinate?
      return false
    end

    def index?
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
      manage?
    end

    def destroy?
      super && user != record
    end

    def user_record_is_subordinate?
      return true if record.is_a?(Class)
      return false if %w[regional_admin super_admin].include?(record.role)
      return false unless (record.available_languages & user.available_languages).present?
      return true
    end

  end
end
