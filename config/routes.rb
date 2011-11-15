Costs::Application.routes.draw do
  root :to => 'costs#index', :as => 'home'
  match 'auth', :to => 'costs#auth', :as => 'auth'
  match 'logout', :to => 'costs#logout', :as => 'logout'
  match 'costs/district/:name', :to => 'costs#district_costs', :as => 'district_costs'
  match 'component/:id/activities', :to => 'costs#component', :as => 'activities'
  match 'region/:id/districts', :to => 'costs#region', :as => 'region'
end
