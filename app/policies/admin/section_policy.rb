module Admin
  class SectionPolicy < Admin::ArticlePolicy

    def show?
      false
    end

    def sort?
      update_structure?
    end

    def destroy?
      update_structure?
    end

    def publish?
      regional_admin? and locale_allowed?
    end

  end
end
