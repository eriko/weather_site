ActionController::Routing::Routes.draw do |map|
  map.resources :user, :active_scaffold => true
  map.resources :description, :active_scaffold => true
  
  map.resources :sparklines
  map.sparklines "sparklines/:action/:id/image.png", :controller => "sparklines"

  map.weather '/today_temp_graph', :controller => 'weather', :action => 'graph_temp' , :hours => "24"
  map.waether "/get_data" , :controller => 'weather' , :action => 'get_data'
  map.waether "/current_weather" , :controller => 'weather' , :action => 'current_weather'
  map.weather '/day_temp', :controller => 'weather', :action => 'day_temp' 
  map.weather '/two_day_temp', :controller => 'weather', :action => 'two_day_temp' 
  map.weather '/day_solar', :controller => 'weather', :action => 'day_solar' 
  map.weather '/two_day_solar', :controller => 'weather', :action => 'two_day_solar' 
  map.weather '/day_solar_max', :controller => 'weather', :action => 'day_solar_max' 
  map.weather '/two_day_solar_max', :controller => 'weather', :action => 'two_day_solar_max' 
  map.weather '/graph_temp/:hours', :controller => 'weather', :action => 'graph_temp' , :hours => "24"
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "weather"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.comatose_admin
  map.comatose_root 'station', :layout=>'weather_layout'
end
