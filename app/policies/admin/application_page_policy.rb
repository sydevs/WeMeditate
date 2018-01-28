module Admin
  class ApplicationPagePolicy < Admin::ApplicationPolicy

    def update?
      editor? and locale_allowed?
    end

    def create?
      editor? and locale_allowed?
    end
    
  end
end
