# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'time'

AppLairoflithCom::Application.load_tasks

task :promote do
  app_name = 'app.lairoflith.com'
  home_dir = "/home/#{ENV['USER']}"

  # create a staging directory based on date.
  staging_dir = "#{home_dir}/history/#{app_name}-#{DateTime.now.strftime}"
  mkdir_p staging_dir

  # sync files to that directory 
  system "rsync -a --exclude=\*.swp --exclude tmp --exclude log --exclude .git ./ #{staging_dir}"

  # create log and tmp directories
  mkdir_p "#{staging_dir}/log"
  mkdir_p "#{staging_dir}/tmp"

  # create the big symlink 
  prod_dir = "#{home_dir}/#{app_name}"
  safe_unlink prod_dir
  ln_s staging_dir, prod_dir

  # switch over to the prod directory
  chdir prod_dir
  system "RAILS_ENV=production rake db:migrate"
  system "bundle exec rake assets:precompile"
  system "RAILS_ENV=production rake sitemap:refresh:no_ping"
  system "RAILS_ENV=production rake ts:index"
  system "RAILS_ENV=production rake ts:stop"
  system "RAILS_ENV=production rake ts:start"
end
