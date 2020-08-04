## MOOD FILTER
# A mood refers to the feeling given by a particular music track, so that users can filter by what they want to hear.

# TYPE: FILTER
# A mood is considered to be a "Filter", which is used to categorize the Track model

class Stream < ApplicationRecord

  # Extensions
  extend ArrayEnum
  audited
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable

  # Associations
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
  array_enum recurrence: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }, array: true

  # Validations
  validates_presence_of :name, :slug, :excerpt, :stream_url
  validates_presence_of :location, :time_zone_identifier, :time_zone_offset, :target_time_zones
  validates_presence_of :recurrence, :start_date, :start_time, :end_time
  validates :thumbnail_id, presence: true, if: :persisted?
  validates :duration, numericality: { greater_than: 0 }

  # Scopes
  scope :q, -> (q) { where('name ILIKE ?', "%#{q}%") if q.present? }
  scope :public_stream, -> { publicly_visible.where.not(content: nil).where(locale: Globalize.locale) }
  scope :for_time_zone, -> (time_zone) { select('streams.*', "#{time_zone.utc_offset / 1.hour} = ANY(target_time_zones) AS featured", "ABS(streams.time_zone_offset - #{time_zone.utc_offset / 1.hour}) AS distance").order(featured: :desc, distance: :asc).first }

  # Callbacks
  before_validation :set_time_zone_offset

  # Include everything necessary to render this model
  def self.preload_for mode
    includes(:media_files)
  end

  # Shorthand for the stream thumbnail image file
  def thumbnail
    media_files.find_by(id: thumbnail_id)&.file
  end

  def live?
    seconds_until_next_stream_time < 5.minutes
  end

  def time_zone
    ActiveSupport::TimeZone.new(time_zone_identifier) rescue Time.zone
  end

  def duration
    Time.parse(end_time) - Time.parse(start_time)
  end

  def seconds_until_next_stream_time
    next_stream_time - time_zone.now
  end

  def next_stream_time
    current_time = time_zone.now
    current_date = current_time.beginning_of_day
    puts "CURRENT DATE #{current_date.to_s(:short)} / TIME #{current_time.to_s(:short)} (#{time_zone.name})"
    countdown_time = next_stream_time_for(current_date)
    puts "COUNTDOWN TIME OPT 1: #{countdown_time}"
    countdown_time = next_stream_time_for(current_date + 1.day) if current_time > countdown_time + duration
    puts "COUNTDOWN TIME OPT 1: #{countdown_time}"
    countdown_time
  end

  def next_stream_time_for date
    weekday = Stream.recurrences.key(date.wday)
    puts "CURRENT WEEKDAY #{weekday}"
    if recurrence.include? weekday
      time = start_time.split(':')
      puts "START TIME #{time}"
      date.to_time.change(hour: time[0].to_i, min: time[1].to_i)
    else
      puts "#{weekday} not in #{recurrence}"
      next_stream_time_for(date + 1.day)
    end
  end

  private

    def valid_end_time?
      Time.parse(end_time) > Time.parse(start_time)
    end

    def set_time_zone_offset
      return unless time_zone_identifier_changed?

      time_zone_data = ActiveSupport::TimeZone.new(time_zone_identifier) rescue nil
      return if time_zone_data.nil?

      self[:time_zone_offset] = time_zone_data.utc_offset / 1.hour
    end

end
