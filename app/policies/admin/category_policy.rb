module Admin
  class CategoryPolicy < Admin::ApplicationResourcePolicy

    def sort?
      super_admin?
    end

  end
end
