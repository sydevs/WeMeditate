module Admin
  class MediaFilePolicy < Admin::ApplicationPolicy

    def index?
      false
    end

    def create?
      true
    end

    def update?
      create?
    end

    def destroy?
      false
    end

  end
end
