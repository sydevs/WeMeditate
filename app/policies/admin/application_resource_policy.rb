module Admin
  class ApplicationResourcePolicy < Admin::ApplicationPolicy

    def update?
      regional_admin? and locale_allowed?
    end

  end
end
