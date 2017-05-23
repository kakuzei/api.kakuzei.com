class ApplicationController < ActionController::API
  %i[bad_request internal_server_error not_found].each do |error|
    define_method(error) { head(error) }
  end

  # rescue_from order is important
  rescue_from StandardError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Error::FileNotFound, with: :not_found
end
