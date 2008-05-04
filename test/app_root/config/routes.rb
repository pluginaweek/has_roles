ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => 'home', :action => 'index'
  map.connect ':controller/:action/:id'
end
