class Audit < Audited::Audit

  # Scopes
  default_scope { order(created_at: :desc) }
  scope :with_associations, -> { includes(:user, :auditable) }

end
