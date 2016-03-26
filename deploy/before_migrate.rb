rails_env = new_resource.environment["RAILS_ENV"]
devise_secret_key = new_resource.environment["DEVISE_SECRET_KEY"]

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute "rake assets:precompile" do
 cwd release_path
 command "bundle exec rake assets:precompile"
 environment "RAILS_ENV" => rails_env, "DEVISE_SECRET_KEY" => devise_secret_key
end
