class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :insist_on_auth, :except => [:auth]
  before_filter :admins_for_settings, :only => [:settings]

  def insist_on_auth
    return redirect_to auth_path(:next => request.path) unless session[:auth]
  end

  def admins_for_settings
    unless session[:admin] then
      flash[:error] = %[Only admins can see settings.]
      redirect_to auth_path
    end
  end
end
