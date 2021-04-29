## ANALYTICS HELPER
# Helper methods for google analytics events.

module AnalyticsHelper

  def gtm_record record, prefix: nil
    return nil if record.nil?

    if record.respond_to?(:role)
      global_name = record.role.titleize
    else
      global_name = dom_id(record).titleize
    end

    local_name = record.name

    if prefix
      global_name = "#{prefix.split('.').last.titleize} - #{global_name}"
      local_name = "#{translate(prefix)} - #{local_name}"
    end

    { gtm: { global: global_name, local: local_name } }
  end

  def gtm_label translation_string
    global = translation_string.split('.').last.titleize
    local = translate(translation_string).gsub('<br>', ' ')

    { gtm: { global: global, local: local } }
  end

end
