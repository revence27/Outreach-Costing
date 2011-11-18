class CostsController < ApplicationController
  respond_to :json, :html

  def index
    @regions    = Region.by_name
    @components = Component.by_name
  end

  def generate
    @data       = JSON.parse(URI.unescape(request[:relations]))
    @partitions = [
                   ['Vaccines and Drugs Needed Annually', :vacc],
                   ['Estimated Cost of Supplies (in USD)', :esti],
                   ['Quarter 1 Supplies', :q1],
                   ['Quarter 2 Supplies', :q2],
                   ['Quarter 3 Supplies', :q3],
                   ['Quarter 4 Supplies', :q4],
                   ['Total Annual Cost of Supplies', :tot_annual],
                   ['Cost for 10% Wastage', :waste],
                   ['Birth Registration', :bdr],
                   ['Total Cost for Birth and Death Registration', :bdr_cost],
                   ['Overall Total Cost for Implementation', :overall]
                  ]
    @districts  = District.where :id => request[:district]
    @components = Component.where(['id IN (?)', @data['components']]).order 'created_at ASC'
    render 'generate.html.haml', :layout => false
  end

  def region
    them = Region.find_by_id(request[:id])
    respond_with({:region => them.name, :country => them.country.name, :districts => them.districts.order('name ASC').map do |dist|
      answer = dist.attributes
      answer['population'] = dist.district_data.attributes['population']
      answer
    end})
  end

  def activity
    respond_with(Activity.find_by_id(request[:id]).activity_items.order('created_at ASC'))
  end

  def component
    # respond_with(Component.find_by_id(request[:id]).activities.order('created_at ASC'))
    respond_with(Activity.where(['component_id IN (?)', Component.where(['id IN (?)', JSON.parse(request[:id])])]))
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
