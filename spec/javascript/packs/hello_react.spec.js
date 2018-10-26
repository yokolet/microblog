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