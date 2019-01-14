## INSTRUMENT FILTER
# An instrument filter signals what sounds are being used in a music Track,
# so that users can filter Tracks for just the kind of music they want to listen to.
# Eg. Sitar, Piano, Voice, Drums, etc

# TYPE: FILTER
# A goal is considered to be a "Filter", which is used to categorize the Track model

class InstrumentFilter < ApplicationRecord

  # Extentions
  translates :name

  # Associations
  has_and_belongs_to_many :tracks
  mount_uploader :icon, IconUploader

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(instrument_filter_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { joins(:translations).where('instrument_filter_translations.name ILIKE ?', "%#{q}%") if q.present? }

  def preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations)
    end
  end

end
