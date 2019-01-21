module Admin
  class MediaFilePolicy < Admin::ApplicationPolicy

    def index?
      translator?
    end

    def create?
      translator?
    end

    def trash?
      clean?
    end

    def clean?
      super_admin?
    end

  end
end
