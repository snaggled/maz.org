set :application, "maz.org"
set :repository,  "git@github.com:bcm/maz.org.git"
set :deploy_to, "/var/www/maz"

role :web, "maz.org"
role :app, "maz.org"

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

# XXX: symlink shared/stuff into public
# XXX: symlink shared/production.yml into config/environments

after "deploy:update_code", "deploy:unpack"

namespace :deploy do
  desc 'Unpack bundled gem dependencies'
  task :unpack, :roles => :app do
    run "cd #{release_path} && bundle install --without=test && bundle lock"
  end

  desc 'Restart Passenger'
  task :restart, :roles => :app do
    run "mkdir -p #{current_path}/tmp"
    run "touch #{current_path}/tmp/restart.txt"
  end
end
