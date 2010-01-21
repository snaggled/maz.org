ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'foursquare' do |fs|
    fs.root
    fs.checkins 'checkins', :action => 'checkins'
  end
end
