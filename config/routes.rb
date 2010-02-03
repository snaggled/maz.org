ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'home' do |home|
    home.root
    home.activities 'activities', :action => 'activities'
  end
end
