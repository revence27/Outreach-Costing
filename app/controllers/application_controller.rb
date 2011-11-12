class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :insist_on_auth, :except => [:auth]

  def insist_on_auth
    return redirect_to auth_path(:next => request.path) unless session[:auth]
  end
end
