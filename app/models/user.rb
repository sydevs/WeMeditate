## TREATMENT
# In the context of this website a user is an editor of the site, there are no public users.

class User < ApplicationRecord

  # Extensions
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable, :lockable, :trackable

  # Associations
  has_many :articles, inverse_of: :owner
  has_one :author, required: false
  enum role: %i[translator writer editor regional_admin super_admin]

  # Validations
  validates :name, presence: true
  validates :email, format: { with: Devise::email_regexp }, presence: true, uniqueness: true
  validates :role, presence: true

  # Scopes
  default_scope { order(:role, :name) }
  scope :active, -> { where('last_sign_in_at > ?', 30.days.ago) }
  scope :inactive, -> { where(last_sign_in_at: nil).or(where('last_sign_in_at <= ?', 30.days.ago)) }
  scope :pending, -> { where.not(invitation_created_at: nil).where(invitation_accepted_at: nil) }
  scope :for_locale, -> { where('languages = \'{}\' OR ? = ANY(languages)', I18n.locale) }
  scope :q, -> (q) { where('email ILIKE ?', "%#{q}%") if q.present? }
  
  # A user is active if they've signed in in the last 30 days
  def active?
    last_sign_in_at.present? && last_sign_in_at > 30.days.ago
  end

  # Override the lannguages writer so that we can convert them from symbols
  def languages= list
    super (list.map(&:to_sym) & I18n.available_locales).map(&:to_s)
  end

  # Override the languages accessor so that we can convert them to symbols
  def languages
    super.map(&:to_sym)
  end

  # Returns a list of languages which this user doesn't already have associated with them.
  def available_languages
    all_languages? ? I18n.available_locales : languages
  end

  # Returns true if the user is able to manage all languages.
  def all_languages?
    !self[:languages].present?
  end

  # Has this user accepted their invitation?
  def pending_invitation?
    !new_record? && invitation_accepted_at.nil?
  end

end
