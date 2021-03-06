# config valid only for current version of Capistrano
lock '3.6.0'

# デプロイするアプリケーション名
set :application, 'achieve'

# cloneするgitのリポジトリ
set :repo_url, 'https://github.com/entmind/achieve'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# deployするブランチ。デフォルトはmasterなので、無くても可能。
# deployするブランチを変更したい場合は、.envに変数を追加します。例）BRANCH='develop'
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
# deploy先のディレクトリ。
set :deploy_to, '/var/www/achieve'

# シンボリックリンクを張るフォルダ・ファイル
set :linked_files, %w{.env config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
#set :default_env, {
#  rbenv_root: "/usr/local/rbenv",
#  path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH",
#  AWS_ACCESS_KEY_ID: ENV["AWS_ACCESS_KEY_ID"],
#  AWS_SECRET_ACCESS_KEY: ENV["AWS_SECRET_ACCESS_KEY"],
#  IMG_UP_AWS_S3_ACCESS_KEY_ID: ENV["IMG_UP_AWS_S3_ACCESS_KEY_ID"],
#  IMG_UP_AWS_S3_SECRET_ACCESS_KEY: ENV["IMG_UP_AWS_S3_SECRET_ACCESS_KEY"]
#}

# Default value for keep_releases is 5
# 保持するバージョンの個数
set :keep_releases, 5

# Rubyのバージョン
set :rbenv_ruby, '2.3.0'
set :rbenv_type, :system

# 出力するログのレベル
set :log_level, :debug

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end