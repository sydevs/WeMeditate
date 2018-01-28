module Admin
  class CityPolicy < Admin::ApplicationPagePolicy

    def lookup?
      update? || create?
    end

  end
end
  