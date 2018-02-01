module Admin
  class ApplicationPagePolicy < Admin::ApplicationPolicy

    def show?
      review?
    end

    def update?
      editor? and locale_allowed?
    end

    def create?
      editor? and locale_allowed?
    end

    def destroy?
      super and record.translated_locales.include? I18n.locale
    end

    def review?
      record.draft? and regional_admin? and locale_allowed?
    end
    
  end
end
