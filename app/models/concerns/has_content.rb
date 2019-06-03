## HAS CONTENT CONCERN
# This concern should be added to models have arbitrary body content

module HasContent

  extend ActiveSupport::Concern

  included do |base|
    base.has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all, autosave: true
    base.has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
    # base.validates :content, presence: true
  end

  def consolidate_media_files!
    media_file_ids = JSON.parse(content)['media_files']
    media_files.where.not(id: media_file_ids).destroy_all
  end

  def media_file media_file_id
    media_files.find_by(id: media_file_id)&.file
  end

end
