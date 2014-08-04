require 'action_view/helpers/text_helper'

module AnonymousFeedback
  module ServiceFeedbackHelper
    extend ActionView::Helpers::TextHelper

    RATING_LABELS = {
      5 => "Very satisfied",
      4 => "Satisfied",
      3 => "Neither satisfied or dissatisfied",
      2 => "Dissatisfied",
      1 => "Very Dissatisfied",
    }

    def label_for_rating(rating)
      "#{RATING_LABELS[rating]} <span class='text-muted'>(rating: #{rating})</span>".html_safe
    end

    def css_classes_for_rating(rating)
      case rating
      when 4..5 then "progress-bar-success"
      when 3 then "progress-bar-warning"
      when 1..2 then "progress-bar-danger"
      end
    end
  end
end
