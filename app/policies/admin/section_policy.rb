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

    # TODO: Remove this function and deal with the subsequent issue
    def review?
      false
    end

  end
end
