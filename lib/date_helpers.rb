module DateHelpers
  extend self

  def current_week
    Time.now.strftime("%V").to_i
  end

  def current_year
    Time.now.strftime("%G").to_i
  end

  def sunday?
    Time.now.sunday?
  end

  def number_of_weeks(year, week_num)
    year * 52 + week_num
  end
end
