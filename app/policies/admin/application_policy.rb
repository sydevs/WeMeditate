module Admin
  class ApplicationPolicy < ::ApplicationPolicy

    def index?
      update? || create? || destroy?
    end

    def show?
      record.has_content? && index?
    end

    def destroy?
      super_admin? && can_access_locale? && record.translated_locales&.include?(I18n.locale)
    end

    def sort?
      false
    end

    def review?
      publish?
    end

    def preview?
      publish?
    end

    def update_translation?
      update?
    end

    def update_structure?
      update?
    end

    # HELPER METHODS
    def admin?
      regional_admin? || super_admin?
    end

    def super_admin?
      user.super_admin?
    end

    def regional_admin?
      user.regional_admin?
    end

    def editor?
      user.editor?
    end

    def translator?
      user.translator?
    end

    def can_access_locale?
      user.available_languages.include? I18n.locale
    end

    def owns_record?
      true
    end

  end
end
