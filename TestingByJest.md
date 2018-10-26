# Testing by Jest

This document explains how to add Jest, which is a React testing framework.

1. Install Jest

    Since Jest is a JavaScript library, use `yarn` to add it.
    At the same time, install babel-jest and babel-preset-es2015.

    ```bash
    $ yarn add --dev jest babel-jest babel-preset-es2015
    ```

    - The yarn installs `regenerator-runtime` without specifying explicitly.

    > __Babel__: JavaScript compiler to covert ECMAScript 2015+ into a
    > backwards compatible version of JavaScript.

2. Add a config to `package.json` to tell Jest where to find tests

    For Jest, test files can resides anywhere. Jest will find all `*.test.js`
    and run it. However, in Rails way, with RSpec, test files should
    be under `spec` directory.

    - Create `spec/javascript` directory
    ```bash
    $ mkdir -p spec/javascript
    ```

    - Add below to `package.json`
    ```json
    "jest": {
      "roots": [
        "spec/javascript"
      ]
    },
    "scripts": {
      "spec": "jest"
    }
    ```

    - Test whether the setup works

    Tentatively, adds `spec/javascript/sum.spec.js` with the content below.
    ```javascript
    test('1 + 1 equals 2', () => {
      expect(1 + 1).toBe(2);
    });
    ```
    Run the command,
    ```bash
    $ yarn spec
    ```
    Then, the result below will show up.
    ```bash
    yarn run v1.10.1
    warning package.json: No license field
    $ jest
     PASS  spec/javascript/sum.spec.js
      ✓ 1 + 1 equals 2 (3ms)

    Test Suites: 1 passed, 1 total
    Tests:       1 passed, 1 total
    Snapshots:   0 total
    Time:        3.456s
    Ran all test suites.
    ✨  Done in 5.98s.
    ```
    Remove `spec/javascript/sum.spec.js` if Jest ran successfully.

3. Add Babel setup to `.babelrc`

    Add `"es2015"` in the presets block.

    ```json
    {
      "presets": [
        "es2015",
        [
          "env",
          {
            "modules": false,
         // other config follows
    ```

4. Add another config to `package.json` to tell Jest where to find modules

    Add `"moduleDirectories"` block in the `"jest"` section.

   ```json
   "moduleDirectories": [
     "node_modules",
     "app/javascript"
   ]
   ```

5. Install Enzyme

    __Enzyme__ is a JavaScript testing utility for React. It renders
    React components in the test environment. Install Enzyme as in below.
    This app uses React version 16.6.0, so the adapter's version is 16.

    ```bash
    $ yarn add --dev enzyme enzyme-adapter-react-16
    ```

6. Setup Enzyme

    - Create a setup file `spec/javascript/setupTests.js`
    ```bash
    $ touch spec/javascript/setupTests.js
    ```
    - Add the content below to `spec/javascript/setupTests.js`
    ```js
    import Enzyme from 'enzyme'
    import Adapter from 'enzyme-adapter-react-16'
    
    Enzyme.configure({ adapter: new Adapter() })
    ```
    - Add setup path in jest section of `package.json`
    ```json
    "jest": {
      "roots": [
        "spec/javascript"
      ],
      "moduleDirectories": [
        "node_modules",
        "app/javascript"
      ],
      "setupTestFrameworkScriptFile": "./spec/javascript/setupTests.js
    },
    ```

7. Export React Component for testing

    To test a component, it should be exported. Jest only tests exported
    components.
    
    Add below to the end of `app/javascript/packs/hello_react.jsx`.
    ```javascript
    export default Hello
    ```

8. Write a component test and run

    - Create test file
    ```bash
    $ mkdir -p spec/javascript/packs
    $ touch spec/javascript/packs/hello_react.spec.js
    ```
    - Add content below to `hello_react.spec.js`
    ```jsx harmony
    import React from 'react'
    import { shallow } from 'enzyme'
    import Hello from 'packs/hello_react'
    
    describe('<Hello />', () => {
        describe('when a name is given as a prop', () => {
            it('render Hello React!', () => {
                expect(shallow(<Hello name="React"/>).text()).toBe('Hello React!')
            })
        })

        describe('when no name is given', () => {
            it('render Hello David!', () => {
                expect(shallow(<Hello />).text()).toBe('Hello David!')
            })
        })
    })
    ```
    - Run the command below
    ```bash
    $ yarn spec
    ```
    Then, the result below will show up. The tests should pass.
    ```bash
    yarn run v1.10.1
    warning package.json: No license field
    $ jest
     PASS  spec/javascript/packs/hello_react.spec.js
      <Hello />
        when a name is given as a prop
          ✓ render Hello React! (6ms)
        when no name is given
          ✓ render Hello David! (1ms)
    
    Test Suites: 1 passed, 1 total
    Tests:       2 passed, 2 total
    Snapshots:   0 total
    Time:        5.195s
    Ran all test suites.
    ✨  Done in 7.74s.
    ```

9. References

    - [Setting up Rails with Webpack(er), React and Jest](http://blog.plataformatec.com.br/2018/05/setting-up-rails-with-webpacker-react-and-jest/)
    - [How to setup JavaScript testing in Rails 5.1 with Webpacker and Jest](https://medium.com/@kylefox/how-to-setup-javascript-testing-in-rails-5-1-with-webpacker-and-jest-ef7130a4c08e)
    - [Jest](https://jestjs.io/docs/en/getting-started)
    - [Enzyme](https://airbnb.io/enzyme/)