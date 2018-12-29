## MOOD FILTER
# An mood refers to the feeling given by a particular music track, so that users can filter by what they want to hear.

# TYPE: FILTER
# A mood is considered to be a "Filter", which is used to categorize the Track model

class MoodFilter < ApplicationRecord

  # Extensions
  translates :name

  # Associations
  has_and_belongs_to_many :tracks
  mount_uploader :icon, IconUploader

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(mood_filter_translations: { locale: I18n.locale }) }

end
