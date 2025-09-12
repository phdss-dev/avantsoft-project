class ApplicationController < ActionController::API
  include Authentication

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::UnknownFormat, with: :handle_unknown_format

  def handle_record_not_found
    render json: {error: "Record not found"}, status: :not_found
  end

  def handle_routing_error
    render json: {error: "Route not found"}, status: :not_found
  end

  def handle_unknown_format
    render json: {error: "Invalid format"}, status: :not_acceptable
  end
end
