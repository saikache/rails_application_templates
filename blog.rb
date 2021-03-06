run "rm public/index.html"
remove_file 'Gemfile'
create_file 'Gemfile'
add_source "https://rubygems.org"
gem 'rails', '3.2.13'

gem 'sqlite3' ,:group => [:development, :test]

gem 'devise'
gem 'activeadmin'
gem 'sass-rails',   '~> 3.2.3', :group => :assets
gem 'coffee-rails', '~> 3.2.1', :group => :assets
gem 'uglifier', '>= 1.0.3',   :group => :assets
gem 'jquery-rails' ,'~> 2.0',  :group => :assets
gem 'therubyracer', :platforms => :ruby ,:group =>  :assets

gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"


#gsub_file 'Gemfile', /#.*\n/, "\n"
run 'bundle install'
rake "db:create"
#Running Spree Generator Commands

generate 'bootstrap:install'
if yes?("Do you want to create bootstrap layout  (Yes/No)?")
generate 'bootstrap:layout application fluid'
end

generate 'devise:install'
generate 'devise user'
generate 'active_admin:install'


run "rm public/index.html"
generate(:scaffold, "post name:string content:string")
rake("db:migrate")

append_file 'db/seeds.rb' do <<-'FILE'
AdminUser.create! :email => 'admin@admin.com',:password => "adminadmin"
FILE
end

append_file 'app/models/admin_user.rb' do <<-'FILE'
attr_accessible  :email, :password, :password_confirmation
FILE
end


rake "db:migrate"
rake "db:seed"
generate 'active_admin:resource user'


generate 'active_admin:resource post'

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

say <<-eos

################################################################
   Your new Blog application is ready to go.
run rails s
Now login to admin interface by
localhost:3000/admin
login:admin@admin.com
password: password

eos



