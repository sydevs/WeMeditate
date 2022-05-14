# Needs to_prepare block since we're directly referencing the Audit model
Rails.application.config.to_prepare do
  Audited.config do |config|
    config.audit_class = Audit
    config.max_audits = 50
  end
end
