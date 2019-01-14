module Admin
  class ArtistPolicy < Admin::ApplicationFilterPolicy

    def sort?
      false
    end

  end
end
