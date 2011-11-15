Costs::Application.routes.draw do
  root :to => 'costs#index', :as => 'home'
  match 'auth', :to => 'costs#auth', :as => 'auth'
  match 'logout', :to => 'costs#logout', :as => 'logout'
  match 'costs/district/:name', :to => 'costs#district_costs', :as => 'district_costs'
  match 'region/:id/districts', :to => 'costs#region', :as => 'region'
  match 'component/:id/activities', :to => 'costs#component', :as => 'activities'
  match 'activity/:id/items', :to => 'costs#activity', :as => 'activity_items'
end
