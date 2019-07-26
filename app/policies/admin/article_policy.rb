module Admin
  class ArticlePolicy < Admin::ApplicationPolicy

    class Scope < Scope
      def resolve
        if user.writer?
          scope.where(owner: user)
        else
          super
        end
      end
    end

    def index?
      # This is required to avoid an issue
      # Where it calls update? then update_translation? then owns_record?
      # And that fails because we are querying on Article, not on an individual @article record
      return false unless can_access_locale?
      return true
    end

    def preview?
      # This is required to avoid an issue
      # Where it calls update? then update_translation? then owns_record?
      # And that fails because we are querying on Article, not on an individual @article record
      # TODO: This allows some users to preview an article which they aren't allowed to edit, fix that somehow
      return false unless can_access_locale?
      return true
    end

    def update?
      update_structure? || update_translation?
    end

    def update_translation?
      return false unless can_access_locale?
      return true if translator?
      return true if writer? && owns_record?
      return true if admin?
      return false
    end

    def update_structure?
      (update_translation? && !translator?) || (create? && record.published_at.nil?)
    end

    def create?
      return false unless can_access_locale?
      return true if writer?
      return true if admin?
      return false
    end

    def publish?
      return false unless can_access_locale?
      return true if writer? && owns_record?
      return true if admin?
      return false
    end

    def review?
      publish?
    end

  end
end
