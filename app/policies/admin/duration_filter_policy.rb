module Admin
  class DurationFilterPolicy < Admin::ApplicationFilterPolicy

    # This policy inherits from the generic filter policy

    def update?
      manage?
    end

    def sort?
      false
    end

  end
end
