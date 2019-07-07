## HAS CONTENT CONCERN
# This concern should be added to models have arbitrary body content

module HasContent

  extend ActiveSupport::Concern

  included do |base|
    base.has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
    # base.validates :content, presence: true
  end

  def media_file media_file_id
    media_files.find_by(id: media_file_id)&.file
  end

end
