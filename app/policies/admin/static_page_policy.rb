module Admin
  class StaticPagePolicy < Admin::ApplicationPagePolicy

    def create?
      super_admin? and StaticPage.available_roles.present?
    end

    def destroy?
      false
    end

  end
end
  