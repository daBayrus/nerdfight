class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_if_done

  def check_if_done
    redirect_to team_path(session[:team_id]) if session[:done]
  end
end
