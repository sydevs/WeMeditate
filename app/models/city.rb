class City < ApplicationRecord
  extend FriendlyId

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :name, :slug
  friendly_id :name, use: :globalize
  after_save :geocode_venues

  # Associations
  has_many :sections, -> { order(:order) }, as: :page, dependent: :delete_all
  has_many :program_venues
  mount_uploader :banner, GenericImageUploader

  # Validations
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :banner, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :program_venues, reject_if: :all_blank, allow_destroy: true
  
  # Scopes
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }

  def has_coordinates?
    latitude.present? and longitude.present?
  end

  private
    def geocode_venues
      if program_venues.present?
        ids = []
        attributes = []

        program_venues.each do |program_venue|
          if address_changed? or program_venue.address_changed? or (address.present? and !program_venue.has_coordinates?)
            ids << program_venue.id
            coordinates = Geocoder.coordinates(program_venue.address + ', ' + address)
            print 'Lookup ' + program_venue.address + ', ' + address + ' = ' + coordinates.to_s + "\r\n"

            if coordinates.present?
              attributes << { latitude: coordinates[0], longitude: coordinates[1] }
            else
              attributes << { latitude: nil, longitude: nil }
            end
          end
        end

        ProgramVenue.update(ids, attributes)
        
        print "\r\n"
      end
    end

end
