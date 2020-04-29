## MOOD FILTER
# A mood refers to the feeling given by a particular music track, so that users can filter by what they want to hear.

# TYPE: FILTER
# A mood is considered to be a "Filter", which is used to categorize the Track model

class Stream < ApplicationRecord

  # Extensions
  extend ArrayEnum
  audited

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable

  # Associations
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
  array_enum recurrence: { mondays: 0, tuesdays: 1, wednesdays: 2, thursdays: 3, fridays: 4, saturdays: 5, sundays: 6 }, array: true

  # Validations
  validates_presence_of :name, :slug, :excerpt, :klaviyo_list_id, :stream_url
  validates_presence_of :location, :time_zone, :target_time_zones
  validates_presence_of :recurrence, :start_date, :start_time, :end_time
  validates :thumbnail_id, presence: true, if: :persisted?

  # Scopes
  scope :q, -> (q) { where('name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for mode
    if mode != :preview
      includes(:media_files)
    else
      self
    end
  end

  # Shorthand for the stream thumbnail image file
  def thumbnail
    media_files.find_by(id: thumbnail_id)&.file
  end

  def time_zone_data
    ActiveSupport::TimeZone[self[:time_zone]] rescue nil
  end

  def time_zone_offset
    return nil if time_zone_data.nil?

    time_zone_data.utc_offset / 1.hour
  end

  def self.for_timezone time_zone

  end

end
