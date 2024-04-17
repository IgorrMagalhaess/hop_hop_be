class TripDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  # def start_date_format
  #   object.start_date.strftime("%B %d, %Y")
  # end

  # def end_date_format
  #   object.end_date.strftime("%B %d, %Y")
  # end
end
