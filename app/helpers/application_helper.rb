module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

  def duration_filter_name duration_filter
    time_ago_in_words(duration_filter.minutes.minutes.from_now).titleize
  end

  def markdown content
    rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    rc.render(content).html_safe
  end

end
