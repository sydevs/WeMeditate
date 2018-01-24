class User < ApplicationRecord

  # Extensions
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable

  # Associations
  enum role: [ :editor, :regional_admin, :super_admin ]

  # Validations
  validates :role, presence: true

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

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
