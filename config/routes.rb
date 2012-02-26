Costs::Application.routes.draw do
  root :to => 'costs#index', :as => 'home'
  match 'auth', :to => 'costs#auth', :as => 'auth'
  match 'logout', :to => 'costs#logout', :as => 'logout'
  match 'settings', :to => 'costs#settings', :as => 'settings'
  match 'costs/district/:name', :to => 'costs#district_costs', :as => 'district_costs'
  match 'region/:id/districts', :to => 'costs#region', :as => 'region'
  match 'hsd/:id/subcounties', :to => 'costs#hsd', :as => 'hsd'
  match 'hu/:id/congregations', :to => 'costs#hu', :as => 'hu'
  match 'component/:id/activities', :to => 'costs#component', :as => 'activities'
  match 'activity/:id/items', :to => 'costs#activity', :as => 'activity_items'
  match 'generate/:district', :to => 'costs#generate', :as => 'generate', :via => :post
  match 'record/assumption/:id/:section/:value', :to => 'costs#update_assumption', :as => 'update_assumption', :via => :post
  match 'record/district/:id/:value', :to => 'costs#update_district', :as => 'update_district', :via => :post
end
