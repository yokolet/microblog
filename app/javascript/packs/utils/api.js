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

