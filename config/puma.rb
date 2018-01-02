_proj_path = "#{File.expand_path("../..", __FILE__)}"
_proj_name = File.basename(_proj_path)
_home = ENV.fetch("HOME") { "/home/centos" }

pidfile "#{_home}/run/#{_proj_name}.pid"
bind "unix://#{_home}/run/#{_proj_name}.sock"
directory _proj_path

# workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
