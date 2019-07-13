module Admin
  class UserPolicy < Admin::ApplicationPolicy

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

    def user_record_is_subordinate?
      %i[translator editor].include?(record.role) && record.languages.include?(I18n.locale)
    end

  end
end
