module Admin
  class MediaFilePolicy < Admin::ApplicationPolicy

    def create?
      true
    end

  end
end
