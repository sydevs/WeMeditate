class City < ApplicationRecord
  extend FriendlyId

  # Extensions
  translates :name, :slug
  friendly_id :name, use: :globalize

  # Associations
  has_many :sections, -> { order(:order) }, as: :page, dependent: :delete_all
  mount_uploader :banner, GenericImageUploader

  # Validations
  validates :name, presence: true
  validates :banner, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end

end
