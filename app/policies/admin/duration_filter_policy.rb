module Admin
  class DurationFilterPolicy < Admin::ApplicationFilterPolicy

    # This policy inherits from the generic filter policy

    def sort?
      false
    end

  end
end
