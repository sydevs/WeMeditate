## MEDIA FILE

# TYPE: FILE
# A file that can be attached to any file

class MediaFile < ActiveRecord::Base

  # Extensions
  paginates_per 24

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, MediaFileUploader

  # Validations
  # validates :name, presence: true
  validates :file, presence: true

  # Scopes
  default_scope { order(updated_at: :desc) }

end
