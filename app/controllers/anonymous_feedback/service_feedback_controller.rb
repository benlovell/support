require 'support/requests/anonymous/service_feedback_aggregated_metrics'

module AnonymousFeedback
  class InvalidDate < Exception; end
  class InvalidSlug < Exception; end

  class ServiceFeedbackController < AuthorisationController
    authorize_resource class: Support::Requests::Anonymous::ServiceFeedback
    rescue_from InvalidDate, with: :not_found
    rescue_from InvalidSlug, with: :not_found

    before_filter :load_day, :load_slug

    def index
      @day_aggregate = Support::Requests::Anonymous::ServiceFeedbackAggregatedMetrics.new(@day, @slug).to_h
      @comments_by_rating = comments_by_rating
    end

  private
    def not_found
      render nothing: true, status: 404
    end

    def comments_by_rating
      feedback_groups = Support::Requests::Anonymous::ServiceFeedback.
        with_comments_by_day_and_slug(@day, @slug).
        group_by(&:service_satisfaction_rating)

      Hash[feedback_groups.map { |rating, feedback| [rating, feedback.map(&:details)] }]
    end

    def load_day
      @day = case params[:date]
             when 'today' then Date.today
             when 'yesterday' then Date.yesterday
             when /\d{4}-\d{2}-\d{2}/ then
               begin
                 Date.parse(params[:date])
               rescue ArgumentError
                 raise InvalidDate
               end
             else
               raise InvalidDate
             end
    end

    def load_slug
      @slug = params[:slug]
      all_slugs = Support::Requests::Anonymous::ServiceFeedback.uniq.pluck(:slug)
      raise InvalidSlug unless params[:slug].present? and all_slugs.include?(@slug)
    end
  end
end
