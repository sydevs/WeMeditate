module Admin
  class CityPolicy < Admin::ApplicationPagePolicy

    def lookup?
      update? || create?
    end

    def update_translation?
      update_structure?
    end

  end
end
