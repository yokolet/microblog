# Getting Started

### How this app makes its shape
0. Update tools

    - Bundler
    
    If needed, update `bundler` by `gem update bundler`.
    
    - node, yarn
    
    Make sure node and yarn are the latest or good versions.
    If not, update by `brew` or `nvm`.

0. Database

    Make sure PostgreSQL is the latest or good version.
    Also, make sure PotgreSQL is up and running.

1. Create and app

    `$ rails new microblog --webpack --api -T -d postgresql`

2. Create .ruby-version file

    Only if .ruby-version is not in the app's top directory.
    When the version in `.ruby-version` is changed , the
    Ruby version in Gemfile should be changed accordingly.

    ```bash
    $ cd microblog
    $ echo 2.5.1 > .ruby-version
    ```

3. Add rspec-rails, factory bot, faker, shoulda and databse_cleaner gems to
   development and test block in `Gemfile`.

    ```ruby
    group :development, :test do
      # Call 'byebug' anywhere in the code to stop execution and get a debugger console
      gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
      gem 'database_cleaner', '~> 1.7'
      gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
      gem 'faker', '~> 1.9', '>= 1.9.1'
      gem 'rspec-rails', '~> 3.8'
      gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
    end
    ```

4. Install gems

    ```
    bundle install
    ```

5. Initialize rspec

    ```bash
    $ rails g rspec:install
    Running via Spring preloader in process 71822
          create  .rspec
          create  spec
          create  spec/spec_helper.rb
          create  spec/rails_helper.rb
    ```

    Not to push `.rspec` to a repo, add `.rspec` to `.gitignore`.

6. Setup databases

    `$ rails db:setup`
    
    If postgresql is up and running, no need to create database manually.
    Above command takes care of all including database creations.

    Check whether databases were created by `psql` command.
    
    ```
    $ psql postgres
    postgres=# \l
    ```

7. initialize webpacker

    `$ rails webpacker:install`

8. create post by scaffold

    ```bash
    $ rails g scaffold api/v1/post subject:string content:text
    Running via Spring preloader in process 72213
          invoke  active_record
          create    db/migrate/20181024023549_create_api_v1_posts.rb
          create    app/models/api/v1/post.rb
          create    app/models/api/v1.rb
          invoke    rspec
          create      spec/models/api/v1/post_spec.rb
          invoke      factory_bot
          create        spec/factories/api_v1_posts.rb
          invoke  resource_route
           route    namespace :api do
      namespace :v1 do
        resources :posts
      end
    end
          invoke  scaffold_controller
          create    app/controllers/api/v1/posts_controller.rb
          invoke    rspec
          create      spec/controllers/api/v1/posts_controller_spec.rb
          create      spec/routing/api/v1/posts_routing_spec.rb
          invoke      rspec
          create        spec/requests/api/v1/api_v1_posts_spec.rb
    ```

9. migrate newly created post

    ```bash
    $ rails db:migrate
    == 20170921051752 CreatePosts: migrating ======================================
    -- create_table(:posts)
       -> 0.0335s
    == 20170921051752 CreatePosts: migrated (0.0335s) =============================
    ```

    Check what table(s) were created by `psql` command
    
    ```
    $ psql microblog_development
    microblog_development=# \d
    microblog_development=# \d api_v1_posts
    ```

10. edit `spec/rails_helper.rb` to configure gems

    1. Database Cleaner
    
        ```
        # Add additional requires below this line. Rails is not loaded until this point!
        require 'database_cleaner'
        
        config.use_transactional_fixtures = false
        
        config.before(:suite) do
          DatabaseCleaner.strategy = :transaction
          DatabaseCleaner.clean_with(:truncation)
        end
        
        config.around(:each) do |example|
          DatabaseCleaner.cleaning do
           example.run
          end
        end
        ```

    2. Factory Bot
    
        ```
        # Factory Bot configuration
        config.include FactoryBot::Syntax::Methods
        ```
     
    3. Shoulda Matchers
    
        ```
        Shoulda::Matchers.configure do |config|
          config.integrate do |with|
            with.test_framework :rspec
            with.library :rails
          end
        end
        ```

11. Write model test `spec/models/api/v1/post_spec.rb`

    ```ruby
    require 'rails_helper'
    
    RSpec.describe Api::V1::Post, type: :model do
      it { should validate_presence_of(:subject) }
      it { should validate_presence_of(:content) }
    end
    ```

    Run model spec by `rails spec:models`
    
    Above test fails since the model doesn't have any to
    validate presences.

12. Add validates_presense_of in `app/models/api/v2/post.rb`

    ```ruby
    class Api::V1::Post < ApplicationRecord
      # validation
      validates_presence_of :subject, :content
    end
    ```

    Run model spec again by `rails spec:models`. It should pass
    after the change above.

13. Write request specs for post in `spec/requests/post_spec.rc`

    {% gist 64381a2b9943f2f28ba1878f3e41f18c %}

14. add exception handler `app/controllers/concerns/exception_handler.rb`

    {% gist 46639987f061c97e92764bfb0feabf55 %}

15. modify `app/controllers/application_controller.rb`

    ```ruby
    class ApplicationController < ActionController::API
      include ExceptionHandler
    end
    ```

16. run request specs

    ```bash
    $ bin/rake spec:requests
    Running via Spring preloader in process 925
    /Users/yoko/.rbenv/versions/2.4.1/bin/ruby -I/Users/yoko/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rspec-core-3.6.0/lib:/Users/yoko/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rspec-support-3.6.0/lib /Users/yoko/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rspec-core-3.6.0/exe/rspec --pattern ./spec/requests/\*\*/\*_spec.rb
    .............

    Finished in 1.38 seconds (files took 2.01 seconds to load)
    13 examples, 0 failures
    ```
