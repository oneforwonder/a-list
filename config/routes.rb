ActionController::Routing::Routes.draw do |map|
  map.log_in "log_in", :controller => "user_sessions", :action => "new"
  map.log_out "log_out", :controller => "user_sessions", :action => "destroy"
  
  map.resources :shares
  map.resources :links
  map.resources :comments
  map.resources :friendships
  map.resources :users
  map.resources :user_sessions

  map.root :controller => "users", :action => "new"
end
