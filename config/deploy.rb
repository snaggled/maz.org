set :application, "maz.org"
set :repository,  "git@github.com:bcm/maz.org.git"
set :deploy_to, "/var/www/maz.org"

role :web, "maz.org"
role :app, "maz.org"

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

# XXX: symlink shared/stuff into public

after "deploy:update_code", "deploy:unpack"
after "deploy:update_code", "deploy:update_config"
after "deploy:update_code", "deploy:update_stuff"
after "deploy", "deploy:cleanup"

namespace :deploy do
  desc 'Unpack bundled gem dependencies'
  task :unpack, :roles => :app do
    run "cd #{release_path} && bundle install --without=test --deployment"
  end

  task :update_config, :roles => :app do
    run "ln -nfs #{shared_path}/production.yml #{current_path}/config/environments/"
  end

  task :update_stuff, :roles => :app do
    run "ln -nfs #{shared_path}/stuff #{current_path}/public/"
  end

  desc 'Restart Passenger'
  task :restart, :roles => :app do
    run "mkdir -p #{current_path}/tmp"
    run "touch #{current_path}/tmp/restart.txt"
  end
end
