set :application, "maz.org"
set :repository,  "git@github.com:bcm/maz.org.git"
set :deploy_to, "/var/www/maz"

set :scm, :git
set :use_sudo, false

role :web, "maz.org"
role :app, "maz.org"

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end