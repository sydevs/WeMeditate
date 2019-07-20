## MEDIA FILE

# TYPE: FILE
# A file that can be attached to any file

class MediaFile < ActiveRecord::Base

  # Associations
  belongs_to :page, polymorphic: true
  mount_uploader :file, MediaFileUploader

  # Validations
  validates :file, presence: true

  def name
    File.basename(URI.parse(file.url).path)
  end

end
