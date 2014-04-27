_ = require 'underscore'

sanitize = (user) ->
  _.omit(user, 'hash', 'salt')

exports.user =
  auth: (id, hash, callback) ->
    user = {
      "email": "user@example.domain",
      "hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      "salt": "QWERTY",
      "connections": [ "list of connection objects" ]
    }

    if hash == user.hash
      res = sanitize(user)
      callback(null, res)
    else
      error = 'Invalid hash'
      callback(new Error(error), null)
