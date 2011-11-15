class CostsController < ApplicationController
  respond_to :json, :html

  def index
    @regions    = Region.by_name
    @components = Component.by_name
  end

  def region
    them = Region.find_by_id(request[:id])
    respond_with({:region => them.name, :country => them.country.name, :districts => them.districts.map do |dist|
      answer = dist.attributes
      answer['population'] = dist.district_data.attributes['population']
      answer
    end})
  end

  def component
    respond_with(Component.find_by_id(request[:id]).activities)
  end

  def district_costs
    @district = District.find_by_name request[:name]
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
