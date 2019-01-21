module Admin
  class DurationFilterPolicy < Admin::ApplicationFilterPolicy

    def sort?
      false
    end

  end
end
