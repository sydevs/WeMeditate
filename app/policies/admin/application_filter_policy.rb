module Admin
  class ApplicationFilterPolicy < Admin::ApplicationResourcePolicy

    def sort?
      super_admin?
    end

  end
end
