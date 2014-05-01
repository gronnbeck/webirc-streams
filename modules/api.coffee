db = require './db'
_ = require 'underscore'

API = (ws) ->

  send = (message) ->
    payload = JSON.stringify(message)
    ws.send(payload)

  sendPayload = (payload) ->
    ws.send(payload)

  api =
    identify: (message) ->
      db.user.auth(message.id, message.hash, (err, user) ->
        send(_.extend(message, { success: true }))
        send(user)
      )

  return api


module.exports = API
