module ApplicationHelper

  def translate_day day
    t('date.day_names')[day]
  end

end
