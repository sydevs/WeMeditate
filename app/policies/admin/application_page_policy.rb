module Admin
  class ApplicationPagePolicy < Admin::ApplicationPolicy

    def show?
      update? || create? || destroy?
    end

    def update?
      update_translation? or update_structure?
    end

    def write?
      update?
    end

    def update_translation?
      translator? and locale_allowed?
    end

    def update_structure?
      editor? and locale_allowed?
    end

    def create?
      editor? and locale_allowed?
    end

    def destroy?
      super and record.translated_locales.include? I18n.locale
    end

    def publish?
      regional_admin? and locale_allowed?
    end

  end
end
