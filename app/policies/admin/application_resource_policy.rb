module Admin
  class ApplicationResourcePolicy < Admin::ApplicationPolicy

    def update?
      regional_admin? and locale_allowed?
    end

    def update_structure?
      update?
    end

    def update_translation?
      update?
    end

  end
end
