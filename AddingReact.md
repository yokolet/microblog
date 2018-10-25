# Adding React

1. Install React using webpacker

    This command adds JavaScript libraries and simple React code.

    ```bash
    $ rails webpacker:install:react
    ```

2. Create entry point for React

    The controller will be an entry point for React.

    ```bash
    $ rails g controller home index
    ```

3. Edit `app/controllers/home_controllers.rb`

    This Rails app is setup to API only. By default, controllers
    inherit ApplicationController::API. However, HomeController should
    be a legacy controller which renders a view.
    
    Change a super class to  `ApplicationController::Base`.
    
    ```ruby
    class HomeController < ActionController::Base
      def index
      end
    end
    ```

4. Edit `config/routes.rb`

   Defines routes so that home/index will be a root.
   
   ```ruby
   Rails.application.routes.draw do
     root to: 'home#index'
     # other routes configs here
   end
   ```

5. Create a view

    Since this app is configured as API only, view related files are not
    generated. Those needs to be manually created.
    
    First, create a file.

    ```bash
    $ mkdir -p app/views/home
    $ touch app/views/home/index.html.erb
    ```
    
    Then, add the contents below.
    
    ```ruby
    <!DOCTYPE html>
    <html>
      <head>
        <title>Microblog</title>
          <%= csrf_meta_tags %>
          <%= csp_meta_tag %>
      </head>
    
      <body>
        <%= javascript_pack_tag 'hello_react' %>
      </body>
    </html>
    ```

6. Add favicon.ico

    To avoid a resource loading error, add an empty file.
    ```bash
    $ touch public/favicon.ico
    ```

7. Test React is working

    All were set up. It's time to test React is working.
    
    Start the server by
    
    ```bash
    $ rails s
    ```
    
    On a browser, request the URL, `http://localhost:3000/`.
    On the terminal, the message below should show up.
    
    ```bash
    Processing by HomeController#index as HTML
      Rendering home/index.html.erb
    [Webpacker] Compiling…
    [Webpacker] Compiled all packs in [path_to_app_dir]/microblog/public/packs
      Rendered home/index.html.erb (6830.2ms)
    ```

    Once a complication has done, "Hello React!" will appear on the browser.

8. Handle routing error

    When non-existing path is requested, the app will show Routing Error.
    To avoid showing detailed routes, add a routing error handling.

    Create a controller
    ```bash
    $ rails g controller all_other index
    ```
    
    Edit `app/controllers/all_other_controller.rb` as in below.
    ```ruby
    class AllOtherController < ApplicationController
      def index
        render json: { message: 'Not Found' }, status: :not_found
      end
    end
    ```
    
    Edit config/routes.rb to catch all other not defined paths.
    ```ruby
    match '*path', to: 'all_other#index', via: :all
    ```