ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  map.resources :sparklines
  map.sparklines "sparklines/:action/:id/image.png", :controller => "sparklines"

  
  map.weather '/today_temp_graph', :controller => 'weather', :action => 'graph_temp' , :hours => "24"
  map.waether "/get_data" , :controller => 'weather' , :action => 'get_data'
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
end
