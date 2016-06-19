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

  # avoids an extra line if there is no line 2
  def address_string
    address_info = [:address_line_1, :address_line_2, :address_city, :address_state, :address_zip_code]

    address_info.map{|attribute| object.send(attribute).presence }.compact.join(", ")
  end

  private

  def pretty_date(date)
    date.strftime("%B %e, %Y")
  end
end
