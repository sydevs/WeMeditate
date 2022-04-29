## PROMO PAGE
# This represents a landing webpage on the website.

class PromoPage < ApplicationRecord

  # Extensions
  audited

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable

  # Associations
  belongs_to :owner, class_name: 'User', optional: true

  # Validations
  validates :name, presence: true

  # Scopes
  scope :q, -> (q) { where('promo_pages.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :content
      includes(:media_files)
    when :admin
      includes(:media_files)
    end
  end

end
