## TREATMENT
# In the context of this website a user is an editor of the site, there are no public users.

class User < ApplicationRecord

  # Extensions
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable, :lockable

  # Associations
  has_many :articles, inverse_of: :owner
  enum role: %i[translator writer regional_admin super_admin]

  # Validations
  validates :name, presence: true
  validates :email, format: { with: Devise::email_regexp }, presence: true, uniqueness: true
  validates :role, presence: true

  # Scopes
  default_scope { order(:role, :name) }
  scope :pending, -> { where.not(invitation_created_at: nil).where(invitation_accepted_at: nil) }
  scope :for_locale, -> { where('languages = \'{}\' OR ? = ANY (languages)', I18n.locale) }
  scope :q, -> (q) { where('email ILIKE ?', "%#{q}%") if q.present? }
  
  def languages= list
    super (list.map(&:to_sym) & I18n.available_locales).map(&:to_s)
  end

  def languages
    super.map(&:to_sym)
  end

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

  def pending_invitation?
    !new_record? && invitation_accepted_at.nil?
  end

end
