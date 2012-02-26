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
                   ['Overall Total Cost for Implementation', :overall]
                  ]
    @districts  = District.where :id => request[:district]
    @components = Component.where(['id IN (?)', @data['components']]).order 'created_at ASC'
    @bdr        = @components.where(:name => 'Birth and Death Registration').first
    @bdr_parts  = [
                    ['Cost for Printing Birth Registration Certificates', :certificates],
                    ['Printers and Laptops', :printers_laptops],
                    ['SDA Parish Priest and Sub-County Chief', :priests]
                  ]
    if @bdr then
      @components = @components.where(['id != ?', @bdr.id])
    end
    @management = @components.where(:name => 'Other Associated Costs').first
    @man_parts  = []
    if @management then
      @man_parts  = @management.activities.first.activity_items
      @components = @components.where(['id != ?', @management.id])
    end
    render 'generate.html.haml', :layout => false
  end

  def region
    them = Region.find_by_id(request[:id])
    respond_with({:region => them.name, :country => them.country.name, :districts => them.districts.order('name ASC').map do |dist|
      answer = dist.attributes
      answer['population']    = dist.district_data.attributes['population']
      answer['subdistricts']  = dist.health_sub_districts.order('name ASC').map do |hsub|
        hsub.attributes # TODO: Process further, when the info comes in.
      end
      answer
    end})
  end

  def hsd
    subd  = HealthSubDistrict.find_by_id(request[:id])
    respond_with({:hsd => subd.name, :district => subd.district.name, :subcounties => subd.sub_counties.order('name ASC').map do |subc|
      answer              = subc.attributes
      answer['parishes']  = subc.parishes.order('name ASC').map do |par|
        parans                = par.attributes
        parans['healthunits'] = par.health_units.order('name ASC').map do |hu|
          hu.attributes
        end
        parans
      end
      answer
    end})
  end

  def hu
    congs = HealthUnit.find_by_id(request[:id])
    respond_with({:hu => congs.name, :parish => congs.parish.name, :congregations => congs.congregations.map do |congregation|
      answer                = congregation.attributes
      answer['population']  = congregation.demographics.attributes
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

  def settings
    @assumptions  = Assumption.where(:activity_item_id => nil).order('name ASC')
    @activities   = Activity.order('name ASC')
    @districts    = District.order('name ASC')
  end

  def update_assumption
    assumption  = Assumption.find_by_id(request[:id])
    assumption.send %[#{request[:section]}=], request[:value]
    assumption.save
    render :json => {:answer => true}
  end

  def update_district
    district                          = District.find_by_id request[:id]
    district.district_data.population = request[:value]
    district.district_data.save
    render :json => {:answer => true}
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
