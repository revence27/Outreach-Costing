Costs::Application.routes.draw do
  root :to => 'costs#index', :as => 'home'
  match 'auth', :to => 'costs#auth', :as => 'auth'
  match 'logout', :to => 'costs#logout', :as => 'logout'
end
