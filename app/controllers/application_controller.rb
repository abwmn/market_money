class ApplicationController < ActionController::API
  def render_error(message, status = :bad_request)
    render json: ErrorSerializer.new(message).serialized_json, status: status
  end
end
