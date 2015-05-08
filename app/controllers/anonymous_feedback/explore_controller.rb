require 'support/requests/anonymous/explore'

class AnonymousFeedback::ExploreController < AuthorisationController
  skip_authorization_check

  def new
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new
  end

  def organisations
    @organisation = Organisation.find(params[:id])
  end

  def create
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new(
      params[:support_requests_anonymous_explore_by_url]
    )
    if @explore_by_url.valid?
      redirect_to @explore_by_url.redirect_path
    else
      render :new, status: 422
    end
  end
end
