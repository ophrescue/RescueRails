class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  helper_method :handle_redirect

  def handle_redirect
    if request.xhr?
      head 200
    else
      redirect_to request.referer
    end
  end
end
