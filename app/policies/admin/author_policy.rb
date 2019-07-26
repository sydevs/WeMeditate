module Admin
  class AuthorPolicy < Admin::ApplicationPolicy

    def manage?
      return false unless can_access_locale?
      return true if admin?
      return true if writer? && owns_record?
      return false
    end

    def update?
      update_structure? || update_translation?
    end

    def update_structure?
      manage? || owns_record?
    end

    def update_translation?
      return true if translator? && !record.translated_locales.include?(I18n.locale)
      return manage?
    end

    def create?
      manage?
    end

  end
end
