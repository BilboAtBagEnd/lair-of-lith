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

  prod_dir = "#{home_dir}/#{app_name}"

  # Stop ThinkingSphinx in the current directory
  chdir prod_dir
  system "RAILS_ENV=production rake ts:stop"

  # create the big symlink 
  chdir staging_dir
  safe_unlink prod_dir
  ln_s staging_dir, prod_dir

  chdir prod_dir
  system "RAILS_ENV=production rake db:migrate"
  system "RAILS_ENV=production rake ts:index"
  system "RAILS_ENV=production rake ts:start"
  system "bundle exec rake assets:precompile"
  system "RAILS_ENV=production rake sitemap:refresh:no_ping"
end
