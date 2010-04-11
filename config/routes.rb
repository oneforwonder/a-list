ActionController::Routing::Routes.draw do |map|
  map.log_in "/log_in", :controller => "user_sessions", :action => "new"
  map.log_out "/log_out", :controller => "user_sessions", :action => "destroy"
  
  map.connect "/users/friends", :controller => "users", :action => "friends"
  map.activate "/users/activate/:token", :controller => "users", :action => "activate"
  map.finish_registration "/users/finish_registration/:token", :controller => "users", :action => "finish_registration"
  
  map.resources :shares
  map.resources :links
  map.resources :comments
  map.resources :friendships
  map.resources :users
  map.resources :user_sessions

  map.root :controller => "users", :action => "new"
end
