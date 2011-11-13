class CostsController < ApplicationController
  def index
    @districts = District.by_name
  end

  def logout
    session.delete :auth
    session.delete :admin
    session.delete :user
    redirect_to home_path
  end

  def auth
    if request[:username] then
      session[:alias] = request[:username]
      user = User.find_by_username request[:username]
      if user then
        sha = Digest::SHA1.new << %[#{user.sha1_salt}#{request[:password]}]
        if sha.to_s == user.sha1_pass then
          session[:auth]  = true
          session[:admin] = user.admin?
          session[:user]  = user.id
          redirect_to(request[:next] || home_path)
        else
          flash[:error] = %[Access denied.]
          @users = User.order 'username'
        end
      else
        flash[:error] = %[Access denied.]
        @users = User.order 'username'
      end
    else
      @users = User.order 'username'
    end
  end
end
