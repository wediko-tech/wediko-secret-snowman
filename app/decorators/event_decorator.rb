class EventDecorator < Draper::Decorator
  delegate_all

  # "Some Event" => "SE"
  # "Some Super Awesome Event" => "SSA"
  def abbreviation
    object.title.split(" ").map(&:first).join[0..2].upcase
  end
end
