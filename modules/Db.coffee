_ = require 'underscore'

sanitize = (user) ->
  _.omit(user, 'hash', 'salt')

exports.user =
  auth: (id, hash, callback) ->
    user = {
      email: 'user@example.domain',
      hash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
      id: id
      salt: 'QWERTY'
      connections: [
        {
          id: 'YW4gY29ubmVjdGlvbiBpZGVudGlmaWVy'
          short_name: 'My private network'
          chans: ['ERROR_NOT_IMPLEMENTED']
          privs: ['ERROR_NOT_IMPLEMENTED']
        }
      ]
    }

    if hash == user.hash
      res = sanitize(user)
      callback(null, res)
    else
      error = 'Invalid hash'
      callback(new Error(error), null)
