## TREATMENT
# In the context of this website a user is an editor of the site, there are no public users.

class User < ApplicationRecord

  # Extensions
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable, :lockable

  # Associations
  has_many :articles, inverse_of: :owner
  enum role: %i[translator editor regional_admin super_admin]

  # Validations
  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true

  # Scopes
  default_scope { order(:role, :name) }
  scope :pending, -> { where.not(invitation_created_at: nil).where(invitation_accepted_at: nil) }
  scope :for_locale, -> { where('languages IS null OR languages LIKE ?', "%#{I18n.locale}%") }
  scope :q, -> (q) { where('email ILIKE ?', "%#{q}%") if q.present? }

  # Override this setter so that a user cannot have languages which the website doesn't support.
  def languages= list
    list &= I18n.available_locales.map(&:to_s) # only allow locales from the list of available locales
    super list.join(',')
  end

  # Split the database string into an actual list of locales
  def languages
    langs = super
    if langs
      langs.split(',')
    else
      []
    end
  end

  # Returns a list of languages which this user doesn't already have associated with them.
  def available_languages
    if all_languages?
      I18n.available_locales
    else
      languages.map(&:to_sym)
    end
  end

  # Returns true if the user is able to manage all languages.
  def all_languages?
    not self[:languages].present?
  end

end
