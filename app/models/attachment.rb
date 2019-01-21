## ATTACHMENT
# This is a file attachment which may belong to any other kind of model.
# Typically it is only used by "Page"-type models.

class Attachment < ActiveRecord::Base

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, AttachmentUploader

  # Validations
  validates :uuid, presence: true

end
