require 'mongrel_cluster/recipes'

set :application, "cpr-signup"
set :repository,  "git@github.com:swork/signup.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/rails-apps/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :web, "cpr.renlabs.com"
role :app, "cpr.renlabs.com"
role :db,  "cpr.renlabs.com", :primary => true
