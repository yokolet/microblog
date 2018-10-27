# Calling API

This document explains how React app calls API. The feature is tested by Jest.

1. Setup CORS on Rails side

    When testing React app using Jest or other testing framework,
    Rails should allow CORS. Since this app is setup as API, CORS
    setup is already there. Just uncommenting those works fine.
    
    1. Uncomment `rack-cors` in `Gemfile`
        ```ruby
        # Use Rack CORS for handling Cross-Origin ...
        gem 'rack-cors'
        ```
    2. Install `rack-cors`
        ```bash
        $ bundle install
        ```
    3. Uncomment `config/initializers/cors.rb`
        ```ruby
        Rails.application.config.middleware.insert_before 0, Rack::Cors do
          allow do
            origins '*'
            resource '*',
              headers: :any,
              methods: [:get, :post, :put, :patch, :delete, :options, :head]
          end
        end
        ```
    4. Restart Rails
        Kills the process by Ctrl-D if Rails is running.
        Then, `rails s`

2. Install `whatwg-fetch` JavaScript library

    To make `fetch()` function universal, install `whatwg-fetch`.
    While testing, Jest makes web requests which is not from web
    browser and causes an error without this library.
    
    ```bash
    $ yarn add whatwg-fetch
    ```

3. Create API call function

    1. Create directory and file
    ```bash
    $ mkdir -p app/javascript/packs/utils
    $ touch app/javascript/packs/utils/api.js
    ```
    
    2. Write API call
    ```javascript
    import 'whatwg-fetch'
    
    const API_BACKEND = 'http://localhost:3000/api/v1'
    
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }
    
    export const fetchPosts = () =>
      new Promise((resolve, reject) => {
        fetch(`${API_BACKEND}/posts`, { headers })
          .then(response => response.json())
          .then(json => resolve(json))
          .catch(error => reject(error))
      })
    ```
    
4. Create API test

    1. Create a file
    ```bash
    $ touch spec/javascript/packs/api.spec.js
    ```
    2. Write a test
    ```javascript
    import {fetchPosts} from 'packs/utils/api'
    
    describe('GET api', () => {
      it('gets list of posts', () => {
        return fetchPosts().then(data => {
          expect(Array.isArray(data)).toBe(true)
        })
      })
    })
    ```

5. Run the test
    ```bash
    $ yarn spec
    ```
    
    The tests should pass and show the result below.
    ```bash
    yarn run v1.10.1
    warning package.json: No license field
    $ jest
     PASS  spec/javascript/packs/hello_react.spec.js
     PASS  spec/javascript/packs/api.spec.js
    
    Test Suites: 2 passed, 2 total
    Tests:       3 passed, 3 total
    Snapshots:   0 total
    Time:        6.123s
    Ran all test suites.
    ✨  Done in 7.44s.
    ```

6. References

    - [Unit testing with Jest: Redux + async actions + fetch](https://medium.com/@ferrannp/unit-testing-with-jest-redux-async-actions-fetch-9054ca28cdcd)
    - [Rails 5 API and CORS](https://til.hashrocket.com/posts/4d7f12b213-rails-5-api-and-cors)
    -