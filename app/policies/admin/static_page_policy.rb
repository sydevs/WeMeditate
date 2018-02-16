module Admin
  class StaticPagePolicy < Admin::ApplicationPagePolicy

    def create?
      super_admin? and StaticPage.available_roles.present?
    end

    def update?
      update_translation? or update_structure?
    end

    def update_translation?
      regional_admin? and locale_allowed?
    end

    def update_structure?
      super_admin?
    end

    def destroy?
      super_admin?
    end

  end
end
  