# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, 'summoners_haunt'
set :repo_url, " https://github.com/pharuq/Summoners-Haunt.git"

set :bundle_flags, '--quiet'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# deployするときのUser名（サーバ上にこの名前のuserが存在しAccessできることが必要）
set :user, 'pharuq'
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/rails/summoners_haunt"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

set :log_level, :debug

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", ".rbenv-vars"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
# append :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
append :linked_dirs, "bin", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "bundle", "public/system", "public/assets"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'

  task :init_permission do
    on release_roles :all do
      execute :sudo, :chown, '-R', "#{fetch(:user)}", deploy_to
    end
  end

  task :reset_permission do
    on release_roles :all do
      execute :sudo, :chown, '-R', "rails", deploy_to
    end
  end

  # linked_files で使用するファイルをアップロードするタスク
  # deployが行われる前に実行する必要がある。
  desc 'upload important files'
  task :upload do
    on roles(:app) do |host|
      execute :mkdir, '-p', "#{shared_path}/config"
      upload!('config/database.yml',"#{shared_path}/config/database.yml")
      upload!('config/secrets.yml',"#{shared_path}/config/secrets.yml")
    end
  end

  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
  before :starting, :init_permission
  before :starting, :upload
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after :finished, :reset_permission
end
