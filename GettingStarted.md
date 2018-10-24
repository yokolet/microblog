# Getting Started

### How this app makes its shape
1. Update tools

    - Bundler
    
    It's a good idea to update Bundler before getting things started.
    If the Bundler is not the latest or needs an update, try the
    command below.

    ```bash
    gem update bundler
    ```
    
    - node, yarn
    
    The same as Bundler, it's a good idea to update node and yarn
    if those are not the latest or good versions. Unlike Bundler,
    there are a couple ways of installing node and yarn, for example,
    `brew` or `nvm`. Make sure to use the same tool when those were
    installed. Below is an example by `brew`.

    ```bash
    brew upgrade node yarn.
    ```

2. Database

    Since this app uses PostgreSQL, make sure PostgreSQL is the latest
    or good version. Also, make sure PostgreSQL is up and running.
    If PostgreSQL was installed by `brew` and is a brew service,
    below is the way to check.

    ```bash
    # this tells postgresql status which should be green 'started'
    brew services list
    ```

3. Create and app

    As always, hit `rails new` command to create a Rails app.
    This app will provide API, and use RSpec, PostgreSQL, and
    webpacker.

    `$ rails new microblog --webpack --api -T -d postgresql`

4. Create .ruby-version file

    Only if `.ruby-version` is not in the app's top directory,
    create `.ruby-version`. If auto-generated `.ruby-version` has
    no good version, edit the file to use another version.
    Then, check or update the Ruby version in Gemfile accordingly.

    ```bash
    $ cd microblog
    $ echo 2.5.1 > .ruby-version
    ```

5. Add gems for development and test

   Add rspec-rails, factory bot, faker, shoulda and databse_cleaner
   gems to development and test block in `Gemfile`.

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

6. Install gems

    Install gems added to the Gemfile.

    ```
    bundle install
    ```

7. Initialize rspec

    This app doesn't have test related files since `-T` option was
    specified at the creation. To use RSpec, initialize it.

    ```bash
    $ rails g rspec:install
    Running via Spring preloader in process 71822
          create  .rspec
          create  spec
          create  spec/spec_helper.rb
          create  spec/rails_helper.rb
    ```

    Then, add `.rspec` to `.gitignore` not to push `.rspec` to a repo.

8. Setup databases

    `$ rails db:setup`
    
    If postgresql is up and running, no need to create database manually.
    Above command takes care of all including database creation.

    Check whether databases were created by `psql` command.
    
    ```
    $ psql postgres
    postgres=# \l
    ```

    The microblog_development and microbolog_test databases should show up.

9. Initialize webpacker

    `$ rails webpacker:install`

10. Create `post` by scaffolding

    This app will provides `post` API. This api's version is `v1`, and
    the path looks like, `/api/v1/posts`.

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

11. Migrate newly created post

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

12. Edit `spec/rails_helper.rb` to configure gems

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

13. Write models spec, `spec/models/api/v1/post_spec.rb`

    ```ruby
    require 'rails_helper'
    
    RSpec.describe Api::V1::Post, type: :model do
      it { should validate_presence_of(:subject) }
      it { should validate_presence_of(:content) }
    end
    ```

    Run models spec by
    
    ```bash
    rails spec:models
    ```

    Above test fails since the model doesn't have any clue to
    validate presences.

14. Add validates_presense_of in `app/models/api/v1/post.rb`

    ```ruby
    class Api::V1::Post < ApplicationRecord
      # validation
      validates_presence_of :subject, :content
    end
    ```

    Run models spec again by

    ```bash
    rails spec:models
    ```

    Now, it should pass.

15. Write `GET` request specs for post

    Edit `spec/requests/api/v1/api_v1_posts_spec.rb`. The file looks
    like below.

    ```ruby
    require 'rails_helper'

    RSpec.describe "Api::V1::Posts", type: :request do
      let!(:posts) { create_list(:api_v1_post, 10) }

      describe "GET /api_v1_posts" do
        before { get api_v1_posts_path }
        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end

        it "returns posts" do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json.size).to eq(10)
        end
      end
    end
    ```

    Run requests spec by

    ```bash
    rails spec:requests
    ```

    Everything has been all setup by the scaffolding, so it should pass.


For now, microblog API was confirmed to work using very basic specs.
