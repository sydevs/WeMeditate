module Admin
  class SubtleSystemNodePolicy < Admin::StaticPagePolicy

    # This policy has the same behaviour as the static page policy.
    
    def destroy?
      false
    end

  end
end
