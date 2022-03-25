## CONTENTABLE CONCERN
# This concern should be added to models have arbitrary body content

module Contentable

  extend ActiveSupport::Concern

  def contentable?
    true
  end

  included do |base|
    %i[content].each do |column|
      next if base.try(:translated_attribute_names)&.include?(column) || base.column_names.include?(column.to_s)
      throw "Column `#{column}` must be defined to make the `#{base.model_name}` model `Contentable`"
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid # rubocop:disable Lint/HandleExceptions
      # avoid breaking rails db:create / db:drop etc due to boot time execution
    end

    base.has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
    # base.validates :content, presence: true

    def self.contentable?
      true
    end
  end

  def parsed_content
    return nil unless self[:content].present?

    self[:content].is_a?(Hash) ? self[:content] : JSON.parse(self[:content])
  end

  def content_blocks
    if self[:content].present?
      parsed_content['blocks']
    else
      []
    end
  end

  def media_file media_file_id
    media_files.find_by(id: media_file_id)&.file
  end

  def essential_media_files locale = nil
    result = []

    if locale.nil?
      translated_locales.each do |locale|
        result += essential_media_files(locale)
      end
    else
      Globalize.with_locale(locale) do
        if content_blocks.present?
          content_blocks.each do |block|
            result += block['data']['mediaFiles'] if block['data']['mediaFiles']
          end
        end

        result += [thumbnail_id] if self.has_attribute?(:thumbnail_id)

        if draftable? && has_draft?
          if parsed_draft_content.present?
            parsed_draft_content['blocks'].each do |block|
              result += block['data']['mediaFiles'] if block['data']['mediaFiles']
            end
          end

          result += [parsed_draft['thumbnail_id']] if parsed_draft['thumbnail_id']
        end
      end
    end

    result.uniq
  end

  def cleanup_media_files!
    # TODO: Reimplement the cleanup of media files.
    #media_files.where.not(id: essential_media_files).destroy_all
  end

  def migrate_content!
    return unless parsed_content.present?
    return if parsed_content['markupVersion'] && parsed_content['markupVersion'] > 2

    migrated_blocks = content_blocks.map do |block|
      next unless block['type'] == 'textbox' && block['data']['type'] == 'text'

      block['data']['credit'] = block['data']['title']
      block['data']['caption'] = block['data']['subtitle']
      block['data']['style'] = block['data']['style'] == 'poem' ? 'simple' : 'hero'
    end

    update!(content: parsed_content.merge('blocks' => migrated_blocks, 'markupVersion' => 3).to_json)
  end

  def self.strip_url url
    local_domain = false

    %w[
      wemeditate.co www.wemeditate.co
      wemeditate.com www.wemeditate.com
      wemeditate.fr www.wemeditate.fr
      wemeditate.ru www.wemeditate.ru
      wemeditate.cz www.wemeditate.cz
      wemeditate.it www.wemeditate.it
    ].each do |domain|
      local_domain = domain if url.present? && url.include?(domain)
    end

    local_domain.present? ? url.split(local_domain).last : url
  end

end
