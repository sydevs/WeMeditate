class User < ApplicationRecord

  # Extensions
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable

  # Associations
  enum role: [ :translator, :editor, :regional_admin, :super_admin ]

  # Validations
  validates :email, presence: true
  validates :role, presence: true

  # Scopes
  default_scope { order( :email ) }
  scope :pending, -> { where.not(invitation_created_at: nil).where(invitation_accepted_at: nil) }


  def languages= list
    list &= I18n.available_locales.map {|l| l.to_s} # only allow locales from the list of available locales
    super list.join(',')
  end

  def languages
    langs = super
    if langs
      langs.split(',')
    else
      []
    end
  end

  def available_languages
    if all_languages?
      I18n.available_locales
    else
      languages.map &:to_sym
    end
  end

  def all_languages?
    not self[:languages].present? #or current_user&.super_admin?
  end
end
