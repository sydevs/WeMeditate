class Attachment < ApplicationRecord

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, AttachmentUploader

  # Validations
  validates :uuid, presence: true

end
