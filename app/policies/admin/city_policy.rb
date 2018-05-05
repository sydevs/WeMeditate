module Admin
  class CityPolicy < Admin::ApplicationPagePolicy

    def update?
      update_translation? or update_structure? or update_venues?
    end

    def update_venues?
      editor? and locale_allowed?
    end

    def lookup?
      update? || create?
    end

  end
end
