class EventDecorator < Draper::Decorator
  delegate_all

  # "Some Event" => "SE"
  # "Some Super Awesome Event" => "SSA"
  def abbreviation
    object.title.split(" ").map(&:first).join[0..2].upcase
  end

  def pretty_start_date
    pretty_date(object.start_date)
  end

  def pretty_end_date
    pretty_date(object.end_date)
  end

  private

  def pretty_date(date)
    date.strftime("%B %e, %Y")
  end
end
