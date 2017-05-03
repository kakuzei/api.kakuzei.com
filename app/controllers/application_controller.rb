class ApplicationController < ActionController::API
  %i[bad_request not_found internal_server_error].each do |error|
    define_method(error) { head(error) }
  end

  rescue_from StandardError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Errno::ENOENT, with: :not_found
end
