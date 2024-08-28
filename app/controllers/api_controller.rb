class APIController < ActionController::API
  private

  def query_params
    request.query_parameters
  end
end
