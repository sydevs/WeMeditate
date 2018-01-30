module Admin
  class TreatmentPolicy < Admin::ApplicationResourcePolicy

    def sort?
      super_admin?
    end

  end
end
