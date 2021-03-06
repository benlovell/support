require "gds_api/support_api"

class AnonymousFeedback::ExportRequestsController < AuthorisationController

  def create
    authorize! :read, :anonymous_feedback

    support_api.create_feedback_export_request(export_request_params)
    redirect_to anonymous_feedback_index_path(params.slice(:from, :to, :path, :organisation)),
      notice: "We are sending your CSV file to #{current_user.email}. If you don't see it in a few minutes, check your spam folder."
  end

  def show
    authorize! :read, :anonymous_feedback

    response = support_api.feedback_export_request(params[:id])
    if response["ready"]
      send_file "/data/uploads/support-api/csvs/#{response['filename']}"
    else
      render nothing: true, status: :not_found
    end
  end

  def export_request_params
    clean_params = params.permit(:path, :from, :to, :organisation)
    {
      path_prefix: clean_params[:path],
      from: clean_params[:from],
      to: clean_params[:to],
      organisation: clean_params[:organisation],
      notification_email: current_user.email
    }
  end

private
  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
