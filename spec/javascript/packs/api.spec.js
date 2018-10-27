import {fetchPosts} from 'packs/utils/api'

describe('GET api', () => {
  it('gets list of posts', () => {
    return fetchPosts().then(data => {
      expect(Array.isArray(data)).toBe(true)
    })
  })
})