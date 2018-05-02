class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def has_paper_trail?
    self[:versions].present?
  end
end
