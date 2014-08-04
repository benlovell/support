require 'support/requests/anonymous/explore'

class AnonymousFeedback::ExploreController < AuthorisationController
  authorize_resource class: Support::Requests::Anonymous::Explore
  before_filter :load_explore_params, only: [ :create ]

  def new
    init_explores
  end

  def create
    if @chosen_explore && @chosen_explore.valid?
      redirect_to @chosen_explore.redirect_path
    else
      invalid_submission
    end
  end

private
  def load_explore_params
    if params[:support_requests_anonymous_explore]
      @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new(
        params[:support_requests_anonymous_explore_by_url]
      )
      @chosen_explore = @explore_by_url
    elsif params[:support_requests_anonymous_explore_service_feedback]
      @explore_service_feedback = Support::Requests::Anonymous::ExploreServiceFeedback.new(
        params[:support_requests_anonymous_explore_service_feedback]
      )
      @chosen_explore = @explore_service_feedback
    else
      invalid_submission
    end
  end

  def invalid_submission
    init_explores
    render :new, status: 422
  end

  def init_explores
    @explore_service_feedback ||= Support::Requests::Anonymous::ExploreServiceFeedback.new
    @explore_by_url ||= Support::Requests::Anonymous::ExploreByUrl.new
  end
end
